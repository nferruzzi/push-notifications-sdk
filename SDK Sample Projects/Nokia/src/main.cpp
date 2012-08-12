#include <QApplication>
#include "notificationexample.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    NotificationExample app;
    app.show();
    return a.exec();
}

// End of file
