#include "XmlReader.h"

XmlReader::XmlReader() {
}

XmlReader::~XmlReader() {
}


const QString XmlBasePath = QDir::currentPath() + "/app/native/assets/xml/";	// Base path to the XML folder in your app

QVariantList XmlReader::LoadXML(QString xmlPath){

	// Load the XML data from local file

	bb::data::XmlDataAccess xda;
	QVariant list = xda.load(xmlPath, "/datas/data");
	qDebug()<<xmlPath;
	qDebug()<<list;
	return list.toList();
}
