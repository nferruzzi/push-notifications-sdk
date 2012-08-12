#include <QtGui>

#include <QPluginLoader>
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

#include "qjson/parser.h"
#include "qjson/serializer.h"
#include "serializer.h"
#include "notificationexample.h"
#include "ui_notificationexample.h"
#include "NotificationsManager.h"
#include "QMLWebView.h"

/*
* You can request your own application and service id from:
* https://projects.forum.nokia.com/notificationsapi/wiki/registerservice
*
* Public "example.com" service can be used for testing.
* Sending Notification Id to "example.com" service is not supported.
*/
const QString application_id = "YOUR_APPLICATION_ID";
const QString service_id = "YOUR_SERVICE_ID";

NotificationExample::NotificationExample(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::NotificationExample)
{
    ui->setupUi(this);

	// Connect to Notifications
	manager = new NotificationsManager(application_id, service_id);
	bool success = manager->isValid();

	connect(manager, SIGNAL(onRegisteredForNotifications(QString)), this, SLOT(onRegisteredForNotifications(QString)));
	connect(manager, SIGNAL(onNotificationReceived(QString)), this, SLOT(onNotificationReceived(QString)));

	// Register to Notifications
	ui->textBrowser->append("Registering to Notifications ...");
	manager->registerForNotifications();

    // Update the status to the screen.
    if (!success)
    {
        ui->textBrowser->append("OviServiceInterace was not loaded.");
    }
    else
    {
        ui->textBrowser->append("Ready.");
    }
	webView = 0;
}

NotificationExample::~NotificationExample()
{
	delete ui; ui = 0;
	delete manager; manager = 0;
}

void NotificationExample::on_qjsonButton_clicked()
{
}

void NotificationExample::on_webViewButton_clicked()
{
}

void NotificationExample::on_registerButton_clicked()
{
}

void NotificationExample::on_unregisterButton_clicked()
{
    // Unregister from Notifications
//	ui->textBrowser->append("Unregistering from Notifications...");
//	manager->unregisterFromNotifications();
}

void NotificationExample::on_notificationIdButton_clicked()
{
}

void NotificationExample::on_sendNotificationIdButton_clicked()
{
}

void NotificationExample::on_wakeupCheckBox_stateChanged(int state )
{
}

void NotificationExample::onRegisteredForNotifications(const QString & deviceId)
{
	ui->textBrowser->append("Notification Id: " + deviceId);
}

void NotificationExample::onNotificationReceived(const QString & notification)
{
	ui->textBrowser->append("Message received: " + notification);
}

void NotificationExample::resizeEvent (QResizeEvent* )
{
    showMaximized();
}

// End of file
