#include "QMLWebView.h"
#include <QGraphicsObject>

QMLWebView::QMLWebView(QWidget *parent) :
    QDeclarativeView(parent)
{
	setSource(QUrl("qrc:/FlickableWebView.qml"));
	setResizeMode(QDeclarativeView::SizeRootObjectToView);
}

void QMLWebView::loadUrl(const QString &url)
{
	rootObject()->setProperty("url", url);
}
