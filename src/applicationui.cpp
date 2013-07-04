// Navigation pane project template
#include "applicationui.hpp"
#include "ScoreLoopThread.hpp"

//#include "ScoreloopBpsEventHandler.hpp"
//#include "ScoreloopData.hpp"
#include "ScoreloopDefines.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>

#include <bb/platform/bbm/MessageService>
#include <bb/platform/bbm/Context>

using namespace bb::cascades;
using namespace bb::platform::bbm;

ApplicationUI::ApplicationUI(bb::cascades::Application *app,
		bb::platform::bbm::Context& context) :
		QObject(app), m_context(&context)

{

	qmlRegisterType<ScoreLoopThread>("com.bblive.game", 1, 0, "ScoreLoop"); //SCORELOOP
	qmlRegisterType<QTimer>("bb.cascades", 1, 0, "QTimer");

	// create scene document from main.qml asset
	// set parent to created document to ensure it exists for the whole application lifetime
	QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

	mScoreLoop = ScoreLoopThread::instance(); //SCORELOOP
	QObject::connect(mScoreLoop, SIGNAL(ScoreLoopUserReady(AppData_t*)), this,
			SLOT(scoreLoopLoaded(AppData_t*))); //SCORELOOP
	QObject::connect(mScoreLoop, SIGNAL(SubmitScoreCompleted(ScoreData_t*)),
			this, SLOT(onSubmitScoreCompleted(ScoreData_t*))); //SCORELOOP
	QObject::connect(mScoreLoop, SIGNAL(ScoreLoopUserError()), this,
			SLOT(scoreLoopError())); //SCORELOOP
	qml->setContextProperty("appContext", this);

//	qml->setContextProperty("_scoreloop", scoreloopData);
	XmlReader *xml = new XmlReader();
	qml->setContextProperty("XML", xml); // create root object for the U
	bb::device::DisplayInfo display;
	int width = display.pixelSize().width();
	int height = display.pixelSize().height();

	QDeclarativePropertyMap* displayProperties = new QDeclarativePropertyMap;
	displayProperties->insert("width", QVariant(width));
	displayProperties->insert("height", QVariant(height));

	qml->setContextProperty("DisplayInfo", displayProperties);

	// create root object for the UI
	AbstractPane *root = qml->createRootObject<AbstractPane>();
	// set created root object as a scene
	app->setScene(root);

	mAppData = 0; //SCORELOOP
	setConnectionStatus("0");
	mScoreLoop->start(); //SCORELOOP
}

QString ApplicationUI::currentDir() {
	return QDir::currentPath();
}

void ApplicationUI::scoreLoopLoaded(AppData_t *data) //SCORELOOP
		{
	mAppData = data;
	qDebug() << "Loaded";
	setConnectionStatus("2");
	qDebug() << "Loaded";
}

void ApplicationUI::scoreLoopError() //SCORELOOP
{
	setConnectionStatus("1");
	qDebug() << "Error";
	//mAppData = data;
	//emit(scoreloopError());
}
/*
 void ApplicationUI::onInformLeaderboardFail() //SCORELOOP
 {

 }
 */

void ApplicationUI::onSubmitScoreCompleted(ScoreData_t *scoreData) //SCORELOOP
		{
	mLastScoreData = scoreData;
	emit(submitScoreCompleted());
}

void ApplicationUI::submitScore(int score, int mode) //SCORELOOP
		{
	if (mAppData != 0) {
		ScoreLoopThread::SubmitScore(mAppData, score, mode);
	}
}

void ApplicationUI::loadLeaderboard(const QString &timeframe, int size) //SCORELOOP
		{

	QString result = (getConnectionStatus());
	qDebug() << ("Entro a cargar el leaderboard y el estado es " + result);

	if (result == "0") {
		emit(onInformLoadingdFail());
	}
	if (result == "1") {
		emit(onInformLeaderboardFail());
	} else {
		if (mAppData != 0) {
			if (timeframe == "24-hour") {
				ScoreLoopThread::LoadLeaderboard(mAppData,
						SC_SCORES_SEARCH_LIST_24H, size);
			} else {
				ScoreLoopThread::LoadLeaderboard(mAppData,
						SC_SCORES_SEARCH_LIST_ALL, size);
			}
		}
	}
}

ScoreLoopThread* ApplicationUI::scoreLoop() //SCORELOOP
{
	return ScoreLoopThread::instance();
}

QString ApplicationUI::getValueFor(const QString &objectName,
		const QString &defaultValue) {
	QSettings settings;
	if (settings.value(objectName).isNull()) {
		return defaultValue;
	}
	return settings.value(objectName).toString();
}

QString ApplicationUI::getConnectionStatus() {
	return connectionStatus;
}

void ApplicationUI::setConnectionStatus(QString value) {
	connectionStatus = value;
}

void ApplicationUI::saveValueFor(const QString &objectName,
		const QString &inputValue) {
	QSettings settings;
	settings.setValue(objectName, QVariant(inputValue));
}

void ApplicationUI::shareBBMStatus(QString objectName) {
	m_userProfile = new bb::platform::bbm::UserProfile(m_context, this);
	QString personalMessageString = objectName;

	m_userProfile->requestUpdatePersonalMessage(personalMessageString);
}

