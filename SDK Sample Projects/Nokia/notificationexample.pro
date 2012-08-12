TEMPLATE = app
TARGET = notificationexample
QT        += core gui network declarative
CONFIG += ovinotifications

INCLUDEPATH += . inc src qjson

HEADERS     += inc/notificationexample.h \
    inc/NotificationsManager.h \
    src/QMLWebView.h \
    qjson/stack.hh \
    qjson/serializerrunnable.h \
    qjson/serializer.h \
    qjson/qobjecthelper.h \
    qjson/qjson_export.h \
    qjson/qjson_debug.h \
    qjson/position.hh \
    qjson/parsertest.h \
    qjson/parserrunnable.h \
    qjson/parser_p.h \
    qjson/parser.h \
    qjson/location.hh \
    qjson/json_scanner.h \
    qjson/json_parser.hh
SOURCES     += src/main.cpp \
               src/notificationexample.cpp \
    src/NotificationsManager.cpp \
    src/QMLWebView.cpp \
    qjson/serializerrunnable.cpp \
    qjson/serializer.cpp \
    qjson/qobjecthelper.cpp \
    qjson/parsertest.cpp \
    qjson/parserrunnable.cpp \
    qjson/parser.cpp \
    qjson/json_scanner.cpp \
    qjson/json_parser.cc

CONFIG += mobility
MOBILITY = systeminfo

symbian {
    TARGET.CAPABILITY = NetworkServices
    TARGET.VID = 0
    TARGET.EPOCALLOWDLLDATA = 1
}

simulator {
    
    windows {
        DESTDIR = $$[QT_INSTALL_PREFIX]/../../OviNotifications 
    }

    unix : !mac {
        DESTDIR = $$[QT_INSTALL_PREFIX]/../../OviNotifications/gcc
    }

    mac {
        DESTDIR = $$[QT_INSTALL_PREFIX]/../../OviNotifications/gcc
        applicationName = $$TARGET".app"
        QMAKE_POST_LINK += cp $$[QT_INSTALL_PREFIX]/../../OviNotifications/gcc/*.dylib $$[QT_INSTALL_PREFIX]/../../OviNotifications/gcc/$$applicationName/Contents/MacOS/ &
        QMAKE_POST_LINK += cp $$[QT_INSTALL_PREFIX]/../../OviNotifications/gcc/ombengine $$[QT_INSTALL_PREFIX]/../../OviNotifications/gcc/$$applicationName/Contents/MacOS/ &
        QMAKE_POST_LINK += cp $$[QT_INSTALL_PREFIX]/../../OviNotifications/gcc/xmppservice $$[QT_INSTALL_PREFIX]/../../OviNotifications/gcc/$$applicationName/Contents/MacOS/ &
        QMAKE_POST_LINK += cp $$[QT_INSTALL_PREFIX]/../../OviNotifications/gcc/mopkkn001.tmp $$[QT_INSTALL_PREFIX]/../../OviNotifications/gcc/$$applicationName/Contents/MacOS/ &
    }

}

FORMS += \
    notificationexample.ui
# End of file

RESOURCES += \
    res/res.qrc

OTHER_FILES += \
    res/WebView.qml \
    res/FlickableWebView.qml \
    Framework/qjson/json_parser.yy \
    qjson/json_parser.yy
