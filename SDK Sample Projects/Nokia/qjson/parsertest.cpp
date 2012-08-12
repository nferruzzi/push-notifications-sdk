#include "parsertest.h"
#include "qjson/parser.h"
#include "qjson/serializer.h"
#include <QVariantMap>
#include <QDebug>
#include <QFile>

QJson::Parser parser;
QJson::Serializer serializer;
bool ok;


parsertest::parsertest(QObject *parent) :
    QObject(parent)
{
	QFile file(":/json.txt");
	file.open(QFile::ReadOnly);
	QByteArray json = file.readAll();
	file.close();

	QVariantMap result = parser.parse (json, &ok).toMap();
	 if (!ok) {
		qFatal("An error occurred during parsing");
		exit (1);
	  }

	 qDebug() << "encoding:" << result["encoding"].toString();
	 qDebug() << "plugins:";

	 foreach (QVariant plugin, result["plug-ins"].toList()) {
	   qDebug() << "\t-" << plugin.toString();
	 }

	 QVariantMap nestedMap = result["indent"].toMap();
	 qDebug() << "length:" << nestedMap["length"].toInt();
	 qDebug() << "use_space:" << nestedMap["use_space"].toBool();


	 QVariantList people;

	   QVariantMap bob;
	   bob.insert("Name", "Bob");
	   bob.insert("Phonenumber", 123);

	   QVariantMap alice;
	   alice.insert("Name", "Alice");
	   alice.insert("Phonenumber", 321);

	  people << bob << alice;

	  QJson::Serializer serializer;
	  QByteArray njson = serializer.serialize(people);

	  qDebug() << njson;

}
