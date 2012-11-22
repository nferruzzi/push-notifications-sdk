#include "NotificationsManager.h"

#include <QPluginLoader>
#include <QSystemDeviceInfo>
#include <QHttpRequestHeader>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkProxy>
#include <QDebug>

// Notifications
#include <ovinotificationinterface.h>
#include <ovinotificationsession.h>
#include <ovinotificationinfo.h>
#include <ovinotificationmessage.h>
#include <ovinotificationstate.h>
#include <ovinotificationpayload.h>

QTM_USE_NAMESPACE

// HTTP Proxy definition, if needed for sending notifications.
// If left empty, system wide proxy configuration will be used
const QString http_proxy = "";
const int proxy_port = 8080;

const QString APP_CODE = "YOUR_APP_CODE";
const QString POST_URL = "https://cp.pushwoosh.com/json/1.3/registerDevice";

NotificationsManager::NotificationsManager(const QString & application_id, const QString & service_id)
:	iNotificationSession(0),
	iNotificationId(""),
	application_id(application_id),
	service_id(service_id)
{
	iHttpManager = new QNetworkAccessManager(this);
	connect(iHttpManager, SIGNAL(sslErrors(QNetworkReply *, QList<QSslError>)), this, SLOT(sslErrors(QNetworkReply *, QList<QSslError>)));

#ifndef Q_OS_SYMBIAN
	if (http_proxy != "")
	{
		QNetworkProxy proxy(QNetworkProxy::HttpProxy, http_proxy, proxy_port);
		iHttpManager->setProxy(proxy);
	}

	else
	{
		QNetworkProxyFactory::setUseSystemConfiguration (true);
	}
#endif

	QPluginLoader * loader = new QPluginLoader(ONE_PLUGIN_ABSOLUTE_PATH);
	QObject * serviceObject = loader->instance();
	delete loader; loader = 0;

	if(!serviceObject)
		return;

	// Connext signals to slots.
	connect(serviceObject, SIGNAL(stateChanged(QObject*)), this, SLOT(stateChanged(QObject*)));
	connect(serviceObject, SIGNAL(received(QObject*)), this, SLOT(received(QObject*)));
	connect(serviceObject, SIGNAL(notificationInformation(QObject*)), this, SLOT(notificationInfo(QObject*)));

	// Store the service interface for later usage
	iNotificationSession = static_cast<OviNotificationSession *>(serviceObject);
}

NotificationsManager::~NotificationsManager()
{
	delete iHttpManager; iHttpManager = 0;
	delete iNotificationSession; iNotificationSession = 0;
}

void NotificationsManager::sslErrors(QNetworkReply * reply, const QList<QSslError> &)
{
	reply->ignoreSslErrors();
}

void NotificationsManager::registerForNotifications()
{
	if(!iNotificationSession)
		return;

	iNotificationSession->registerApplication(application_id);
}

void NotificationsManager::unregisterFromNotifications()
{
	if(!iNotificationSession)
		return;

	iNotificationSession->unregisterApplication();
}

void NotificationsManager::stateChanged(QObject* aState)
{
	// State of the application has changed
	OviNotificationState* state = static_cast<OviNotificationState*>(aState);

	// Print out the session state on the screen
	switch (state->sessionState())
	{
		case OviNotificationState::EStateOffline:
		{
			break;
		}
		case OviNotificationState::EStateOnline:
		{
			//can register for pushes now
			iNotificationSession->getNotificationInformation(service_id);
			iNotificationSession->setWakeUp(true);
			break;
		}
		case OviNotificationState::EStateConnecting:
		{
			break;
		}
		default:
		{
			break;
		}
	}

	// Print out the error, if there is any
	if (state->sessionError() != OviNotificationState::EErrorNone)
	{
	}

	delete state; state = 0;
}

void NotificationsManager::notificationInfo(QObject* aData)
{
	// Cast QObject to OviNotificationInfo to access the methods
	OviNotificationInfo* info = static_cast<OviNotificationInfo*>(aData);

	// store NID for later usage
	iNotificationId = info->notificationId();

	//post the notification to the server
	QByteArray dataArray = QUrl::toPercentEncoding( iNotificationId );
    QString post_data = "{\"request\":{\"application\":\"" + APP_CODE + "\", \"language\":\"" + QLocale::system().name().left(2) + "\", \"device_type\":\"4\", \"push_token\":\"" + dataArray + "\", \"hwid\":\"" + QSystemDeviceInfo().imei() + "\"}}";

	QUrl qUrl(POST_URL);
	iHttpManager->post(QNetworkRequest(qUrl), post_data.toLatin1());

	delete info; info = 0;

	emit onRegisteredForNotifications(dataArray);
}

void NotificationsManager::received(QObject* aNotification)
{
	// Casting the QObject to OviNotificationMessage to gain access
	// to all its members.
	OviNotificationMessage* notification = static_cast<OviNotificationMessage*>(aNotification);

	// Show the received notification in the screen
	OviNotificationPayload*  payload =  static_cast<OviNotificationPayload*>(notification->payload());
	QString message = payload->dataString();

	delete payload; payload = 0;
	delete notification; notification = 0;

	emit onNotificationReceived(message);
}
