// Navigation pane project template
#ifndef ApplicationUI_HPP_
#define ApplicationUI_HPP_

#include <QObject>
#include "XmlReader.h"
#include <bb/device/DisplayInfo>
#include "ScoreLoopThread.hpp"
#include <bb/platform/bbm/UserProfile>

using namespace bb::device;
namespace bb
{
namespace platform
{
namespace bbm
{
class Application;
class Context;
class MessageService;
class ScoreloopBpsEventHandler;
}
}
}


/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class ApplicationUI: public QObject
{
	Q_OBJECT

public:
	ApplicationUI(bb::cascades::Application *app,bb::platform::bbm::Context& context);
	virtual ~ApplicationUI() {
	}
	Q_INVOKABLE
	QString currentDir();

	Q_INVOKABLE
	QString getValueFor(const QString &objectName, const QString &defaultValue);Q_INVOKABLE
	void saveValueFor(const QString &objectName, const QString &inputValue);

	Q_INVOKABLE
	void submitScore(int score, int mode); //SCORELOOP
	Q_INVOKABLE
	void loadLeaderboard(const QString &timeframe, int size); //SCORELOOP
	Q_INVOKABLE
	ScoreLoopThread* scoreLoop(); //SCORELOOP

	Q_INVOKABLE
		void shareBBMStatus(QString objectName); //BBM

public Q_SLOTS:
	void scoreLoopLoaded(AppData_t *data); //SCORELOOP
	void onSubmitScoreCompleted(ScoreData_t *scoreData); //SCORELOOP

Q_SIGNALS:
	void submitScoreCompleted(); //SCORELOOP

private:

	AppData_t *mAppData; //SCORELOOP
	ScoreLoopThread *mScoreLoop; //SCORELOOP
	ScoreData_t *mLastScoreData; //SCORELOOP
    bb::platform::bbm::Context* m_context;
    bb::platform::bbm::UserProfile* m_userProfile;


};

#endif /* ApplicationUI_HPP_ */
