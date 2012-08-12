#ifndef QMLWEBVIEW_H
#define QMLWEBVIEW_H

#include <QDeclarativeView>

class QMLWebView : public QDeclarativeView
{
    Q_OBJECT
public:
	explicit QMLWebView(QWidget *parent = 0);

signals:

public slots:
	void loadUrl(const QString &);
};

#endif
