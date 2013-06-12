/*
 * XmlReader.h
 *
 *  Created on: Dec 27, 2012
 *      Author: rion
 */

#ifndef XMLREADER_H_
#define XMLREADER_H_

#include <bb/cascades/Application>
#include <bb/data/XmlDataAccess>

using namespace bb::cascades;

class XmlReader : public QObject{
	Q_OBJECT
public:
	XmlReader();
	virtual ~XmlReader();

	Q_INVOKABLE
	QVariantList LoadXML(QString xmlPath);
};

#endif /* XMLREADER_H_ */
