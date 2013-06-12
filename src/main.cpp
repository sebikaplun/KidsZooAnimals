// Navigation pane project template
#include "applicationui.hpp"
#include <bb/cascades/Application>

#include <QLocale>
#include <QTranslator>
#define QT_DECLARATIVE_DEBUG
#include <Qt/qdeclarativedebug.h>
#include <bb/device/DisplayInfo>

#include "RegistrationHandler.hpp"


using namespace bb::cascades;

void myMessageOutput(QtMsgType type, const char* msg) {
	fprintf(stdout, "%s\n", msg);
	fflush(stdout);
}

Q_DECL_EXPORT int main(int argc, char **argv)
{    // this is where the server is started etc
    Application app(argc, argv);
	qInstallMsgHandler(myMessageOutput);

    // localization support
    QTranslator translator;
    QString locale_string = QLocale().name();
    QString filename = QString( "PruebaTabed_%1" ).arg( locale_string );
    if (translator.load(filename, "app/native/qm")) {
        app.installTranslator( &translator );
    }

    // Every application is required to have its own unique UUID. You should
      // keep using the same UUID when you release a new version of your
      // application.
      // TODO:  YOU MUST CHANGE THIS UUID!
      // You can generate one here: http://www.guidgenerator.com/
	const QUuid uuid(QLatin1String("95aa9e4a-67eb-4d2e-954a-452533ca12d2"));

   	//! [0]
   	      // Register with BBM.
   	      RegistrationHandler *registrationHandler = new RegistrationHandler(uuid, &app);


    // create the application pane object to init UI etc.
    new ApplicationUI(&app,registrationHandler->context());

    // we complete the transaction started in the app constructor and start the client event loop here
    return Application::exec();
    // when loop is exited the Application deletes the scene which deletes all its children (per qt rules for children)
}
