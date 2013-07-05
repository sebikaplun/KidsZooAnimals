APP_NAME = KidsZooAnimals


CONFIG += qt warn_on cascades10

include(config.pri)
LIBS += -lbbdata
LIBS += -lbbdevice
LIBS += -lbbmultimedia
LIBS += -lscoreloopcore -lbbsystem -lbbplatform
LIBS += -lbbplatformbbm
LIBS += ­-lscreen -­lcrypto -­lcurl -­lpackageinfo -­lbbdevice

device {
    CONFIG(debug, debug|release) {
        # Device-Debug custom configuration
    }

    CONFIG(release, debug|release) {
        # Device-Release custom configuration
    }
    
}

simulator {
    CONFIG(debug, debug|release) {
        # Simulator-Debug custom configuration
    }
}

