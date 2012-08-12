#ifndef NOTIFICATIONS_MANAGER
#define NOTIFICATIONS_MANAGER

#include <QNetworkAccessManager>

class OviNotificationSession;

class NotificationsManager : public QObject
{
	Q_OBJECT

private:
	QString application_id;
	QString service_id;

	QNetworkAccessManager * iHttpManager;
	OviNotificationSession * iNotificationSession;
	QString iNotificationId;

private slots:
	// Callback for handling possible SSL errors
	void sslErrors(QNetworkReply * reply, const QList<QSslError> & errors);

	// State of the Notifications application session has been changed. Check the new state and possible error.
	void stateChanged(QObject* aState);

	// Address for the service to identify Notifications application.
	void notificationInfo(QObject* aData);

	// Received notification from the Notifications service.
	void received(QObject* aNotification);

public:
	NotificationsManager(const QString & application_id, const QString & service_id);
	virtual ~NotificationsManager();

	void registerForNotifications();
	void unregisterFromNotifications();

	bool isValid()const { return iNotificationSession != 0; }

signals:
	void onRegisteredForNotifications(const QString & deviceId);
	void onNotificationReceived(const QString & notification);
};

#endif //NOTIFICATIONS_MANAGER
