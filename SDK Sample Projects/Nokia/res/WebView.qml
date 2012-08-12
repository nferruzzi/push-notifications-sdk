import QtQuick 1.0
import QtWebKit 1.0

Rectangle {
	id: rectangle1
	width: 360
	height: 400
	property alias url: webView.url
	property alias html: webView.html

 WebView {
	 id: webView
	 anchors.fill: parent
	 url: "http://google.com"
 }
}
