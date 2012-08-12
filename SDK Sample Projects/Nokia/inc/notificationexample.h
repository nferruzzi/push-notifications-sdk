#ifndef NOTIFICATIONEXAMPLE_H
#define NOTIFICATIONEXAMPLE_H

#include <QMainWindow>
#include <QNetworkAccessManager>

class OviNotificationSession;
class NotificationsManager;

namespace Ui {
    class NotificationExample;
}
class QMLWebView;

class NotificationExample : public QMainWindow
{
    Q_OBJECT

public:
    explicit NotificationExample(QWidget *parent = 0);
    ~NotificationExample();

private:
    Ui::NotificationExample *ui;
	NotificationsManager * manager;
	QMLWebView *webView;

private slots:
    void on_wakeupCheckBox_stateChanged(int );
    void on_sendNotificationIdButton_clicked();
    void on_notificationIdButton_clicked();
    void on_unregisterButton_clicked();
    void on_registerButton_clicked();
	void on_webViewButton_clicked();
	void on_qjsonButton_clicked();

private slots:

	/*!
     * Handles orientation change
     *
     */
    void resizeEvent (QResizeEvent* event);

	void onRegisteredForNotifications(const QString & deviceId);
	void onNotificationReceived(const QString & notification);

private:
};

#endif // NOTIFICATIONEXAMPLE_H

