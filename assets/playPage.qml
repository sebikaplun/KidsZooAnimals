import bb.cascades 1.0
import bb.multimedia 1.0
import bb.data 1.0

Page {
    property int width
    property int height
    property int points: 0
    property int level: 1
    property int latestPoint: 0 
    property int winsInLevel: 0
    property int time: 200
    property int timeMoving: 2000
    property variant lista: []
    property int index: 0
    function startGame() {
        gameTimer.start();
    }

    actions: [
        // General SHARE Framework call
        // Will display all the SHARE Targets available
        InvokeActionItem {
            ActionBar.placement: ActionBarPlacement.Default
            title: "Share"
            query {
                mimeType: "text/plain"
                invokeActionId: "bb.action.SHARE"
            }
            onTriggered: {
                //data = _socialInvocation.encodeQString(generalShare.statusText);
                data = "I am learning about the " + lista[index].backgroundSound + " on Kids Zoo Animals";
                console.log(data);
            }
        },
        ActionItem {
            id: actionLeader
            title: "View Leaderboard"
            imageSource: "asset:///leaderboard.png"
            ActionBar.placement: ActionBarPlacement.Default
            onTriggered: {
                //scoreloopDialog.close();
                var page = leaderPageDefinition.createObject();
                navigationPane.backButtonsVisible = true
                navigationPane.push(page);
            }
        }
    ]
    Container {
        horizontalAlignment: HorizontalAlignment.Center
        layout: DockLayout {
        }
        ImageView {
            imageSource: "asset:///background.jpg"
        }
        attachedObjects: [
            MediaPlayer {
                id: playerAnimal
                sourceUrl: "sounds/correct_sound.mp3"
            },
            GameDialog {
                id: scoreloopDialog
                title: "Level " + (level-1) + " completed!"
                subtitle: "Your Score is " + latestPoint; 
                downBbuttonText: "Continue with game"
                upBbuttonText: "Share on BBM status"
                onMainButtonClick: {
                    
                    appContext.shareBBMStatus("I reached level " + level + " with " + latestPoint+" points in Kids Zoo Animals");
                    //show score loop chart
                    //navigationPane.backButtonsVisible = true NAVIGATION
                }
                onSecondButtonClick: {
                    scoreloopDialog.close();
                    gameTimer.start();
                }
            },
            ComponentDefinition {
                id: leaderPageDefinition
                source: "Leaderboard.qml"
            }
        ]
        Container {
            id: gameContainer
            layout: DockLayout {
            }

            Container {
                id: gameLayout
                layout: DockLayout {
                }
                attachedObjects: [
                    TextStyleDefinition {
                        id: myStyle
                        fontSize: FontSize.XXLarge
                        color: Color.White
                        fontWeight: FontWeight.W400
                    },
                    QTimer {
                        id: gameTimer
                        interval: 200
                        onTimeout: {
                            timeRemaining.value -= 1;
                            if (timeRemaining.value == 0) {
                                raiseAnimationLost.play();
                                fade1.play();
                                fade2.play();
                                fade3.play();
                                fade4.play();
                                fade5.play();
                                fadeImage.play();
                                gameTimer.stop();
                            }
                        }
                    }
                ]

                ImageView {
                    id: imageView
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill

                    animations: [
                        FadeTransition {
                            id: fadeImage
                            duration: 1000
                            fromOpacity: 1
                            toOpacity: 0
                        }
                    ]

                }

                NubeContainerView {
                    id: lbl1
                    text: qsTr("Hello World")
                    verticalAlignment: VerticalAlignment.Top
                    horizontalAlignment: HorizontalAlignment.Left
                    onTouch: {

                        if (event.touchType == TouchType.Up) {
                            raiseAnimationCorrect.play();
                            winsInLevel ++;
                            points = (timeRemaining.value) * level;
                            console.log("wins in level", winsInLevel);
                            if (winsInLevel == 5) {
                                level ++;
                                winsInLevel = 0;
                                console.log("Change level", time);
                                time = time * 0.8;
                                timeMoving = timeMoving * 0.7;
                                gameTimer.interval = time;
                                console.log("Change level", time);
                                appContext.submitScore(points, 0);
                                latestPoint = points;
                                points = 0;
                                gameTimer.stop();
                                scoreloopDialog.start();
                            }
                            playerCorrect.reset();
                            playerCorrect.play();
                            playerAnimal.play();
                            fade1.play();
                            fade2.play();
                            fade3.play();
                            fade4.play();
                            fade5.play();
                            fadeImage.play();

                        }

                    }
                    animations: [
                        TranslateTransition {
                            id: translateAnimation
                            duration: timeMoving
                            onEnded: {
                                translateAnimation.toX = Math.ceil(Math.random() * (width - handler1.layoutFrame.width));
                                translateAnimation.toY = Math.ceil(Math.random() * (height - handler1.layoutFrame.height - 80));
                                translateAnimation.duration = Math.ceil(Math.random() * 4000);
                                translateAnimation.play();
                            }
                        },
                        FadeTransition {
                            id: fade1
                            duration: 1000
                            fromOpacity: 1
                            toOpacity: 0
                        }
                    ]
                    attachedObjects: [
                        // This handler is tracking the layout frame of the button.
                        LayoutUpdateHandler {
                            id: handler1
                            onLayoutFrameChanged: {
                                // Individual layout frame values can be
                                // retrieved from the signal parameter
                                ////console.log("Layout Frame: [" + layoutFrame.x + ", " + layoutFrame.y + layoutFrame.width + ", " + layoutFrame.height + "]");
                            }
                        }
                    ]
                }

                NubeContainerView {
                    id: lbl2
                    verticalAlignment: VerticalAlignment.Top
                    horizontalAlignment: HorizontalAlignment.Left
                    onTouch: {
                        raiseAnimation.play();
                    }
                    animations: [
                        TranslateTransition {
                            id: translateAnimation2
                            duration: timeMoving
                            onEnded: {
                                translateAnimation2.toX = Math.ceil(Math.random() * (width - handler2.layoutFrame.width));
                                translateAnimation2.toY = Math.ceil(Math.random() * (height - handler2.layoutFrame.height - 80));
                                translateAnimation2.duration = Math.ceil(Math.random() * 4000);
                                translateAnimation2.play();
                            }
                        },
                        FadeTransition {
                            id: fade2
                            duration: 1000
                            fromOpacity: 1
                            toOpacity: 0
                        }
                    ]

                    attachedObjects: [
                        // This handler is tracking the layout frame of the button.
                        LayoutUpdateHandler {
                            id: handler2
                            onLayoutFrameChanged: {
                                // Individual layout frame values can be
                                // retrieved from the signal parameter
                                //console.log("Layout Frame: [" + layoutFrame.x + ", " + layoutFrame.y + layoutFrame.width + ", " + layoutFrame.height + "]");
                            }
                        }
                    ]
                }

                NubeContainerView {
                    id: lbl3
                    verticalAlignment: VerticalAlignment.Top
                    horizontalAlignment: HorizontalAlignment.Left
                    onTouch: {
                        raiseAnimation.play();
                    }
                    animations: [
                        TranslateTransition {
                            id: translateAnimation3
                            duration: timeMoving
                            onEnded: {
                                translateAnimation3.toX = Math.ceil(Math.random() * (width - handler3.layoutFrame.width));
                                translateAnimation3.toY = Math.ceil(Math.random() * (height - handler3.layoutFrame.height - 80));
                                translateAnimation3.duration = Math.ceil(Math.random() * 4000);
                                translateAnimation3.play();
                            }
                        },
                        FadeTransition {
                            id: fade3
                            duration: 1000
                            fromOpacity: 1
                            toOpacity: 0
                        }
                    ]
                    attachedObjects: [
                        // This handler is tracking the layout frame of the button.
                        LayoutUpdateHandler {
                            id: handler3
                            onLayoutFrameChanged: {
                                // Individual layout frame values can be
                                // retrieved from the signal parameter
                                //console.log("Layout Frame: [" + layoutFrame.x + ", " + layoutFrame.y + layoutFrame.width + ", " + layoutFrame.height + "]");
                            }
                        }
                    ]
                }

                NubeContainerView {
                    id: lbl4
                    verticalAlignment: VerticalAlignment.Top
                    horizontalAlignment: HorizontalAlignment.Left
                    onTouch: {

                        raiseAnimation.play();
                    }
                    animations: [
                        TranslateTransition {
                            id: translateAnimation4
                            duration: timeMoving
                            onEnded: {
                                translateAnimation4.toX = Math.ceil(Math.random() * (width - handler4.layoutFrame.width));
                                translateAnimation4.toY = Math.ceil(Math.random() * (height - handler4.layoutFrame.height - 80));
                                translateAnimation4.duration = Math.ceil(Math.random() * 4000);
                                translateAnimation4.play();
                            }
                        },
                        FadeTransition {
                            id: fade4
                            duration: 1000
                            fromOpacity: 1
                            toOpacity: 0
                        }
                    ]
                    attachedObjects: [
                        // This handler is tracking the layout frame of the button.
                        LayoutUpdateHandler {
                            id: handler4
                            onLayoutFrameChanged: {
                                // Individual layout frame values can be
                                // retrieved from the signal parameter
                                //console.log("Layout Frame: [" + layoutFrame.x + ", " + layoutFrame.y + layoutFrame.width + ", " + layoutFrame.height + "]");
                            }
                        }
                    ]
                }

                NubeContainerView {
                    id: lbl5
                    verticalAlignment: VerticalAlignment.Top
                    horizontalAlignment: HorizontalAlignment.Left
                    onTouch: {

                        raiseAnimation.play();
                    }
                    animations: [
                        TranslateTransition {
                            id: translateAnimation5
                            duration: timeMoving
                            onEnded: {
                                translateAnimation5.toX = Math.ceil(Math.random() * (width - handler5.layoutFrame.width));
                                translateAnimation5.toY = Math.ceil(Math.random() * (height - handler5.layoutFrame.height - 80));
                                translateAnimation5.duration = Math.ceil(Math.random() * 4000);
                                translateAnimation5.play();
                            }
                        },
                        FadeTransition {
                            id: fade5
                            duration: 1000
                            fromOpacity: 1
                            toOpacity: 0
                        }
                    ]

                    attachedObjects: [
                        // This handler is tracking the layout frame of the button.
                        LayoutUpdateHandler {
                            id: handler5
                            onLayoutFrameChanged: {
                                // Individual layout frame values can be
                                // retrieved from the signal parameter
                                //console.log("Layout Frame: [" + layoutFrame.x + ", " + layoutFrame.y + layoutFrame.width + ", " + layoutFrame.height + "]");
                            }
                        }
                    ]
                }
                ImageView {
                    id: imgWrong
                    imageSource: "asset:///images/cross.hi.png"
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0
                    }
                    scalingMethod: ScalingMethod.AspectFit
                    scaleX: 0.5
                    scaleY: 0.5
                    opacity: 0
                    animations: [
                        ParallelAnimation {
                            id: raiseAnimation
                            FadeTransition {
                                fromOpacity: 0
                                toOpacity: 1
                                duration: 1000
                            }
                            ScaleTransition {
                                fromX: 0.5
                                fromY: 0.5
                                toX: 0.8
                                toY: 0.8
                                duration: 1000
                                easingCurve: StockCurve.DoubleElasticOut
                            }
                            onEnded: {
                                player.play();
                                achicarAnimation.play();
                            }
                        },
                        ParallelAnimation {
                            id: achicarAnimation
                            FadeTransition {
                                fromOpacity: 1
                                toOpacity: 0
                                duration: 1000
                            }
                            ScaleTransition {
                                fromX: 0.8
                                fromY: 0.8
                                toX: 0.5
                                toY: 0.5
                                duration: 1000
                                easingCurve: StockCurve.BackOut
                            }
                        },
                        ParallelAnimation {
                            id: raiseAnimationLost
                            FadeTransition {
                                fromOpacity: 0
                                toOpacity: 0
                                duration: 0
                            }
                            ScaleTransition {
                                fromX: 0.5
                                fromY: 0.5
                                toX: 0.8
                                toY: 0.8
                                duration: 0
                                easingCurve: StockCurve.DoubleElasticOut
                            }
                            onEnded: {
                                //player.play();
                                achicarAnimation.play();
                                timeRemaining.value = 200;
                                reload();
                                gameTimer.start();
                            }
                        }
                    ]
                    attachedObjects: [
                        MediaPlayer {
                            id: player
                            sourceUrl: "sounds/menu_wrong_1.mp3"
                        }
                    ]
                }

                ImageView {
                    id: imgCorrect
                    imageSource: "asset:///images/tick.png"
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0
                    }
                    //scalingMethod: ScalingMethod.AspectFit
                    scaleX: 0.5
                    scaleY: 0.5
                    opacity: 0
                    animations: [
                        ParallelAnimation {
                            id: raiseAnimationCorrect
                            FadeTransition {
                                fromOpacity: 0
                                toOpacity: 1
                                duration: 1000
                            }
                            ScaleTransition {
                                fromX: 0.5
                                fromY: 0.5
                                toX: 0.8
                                toY: 0.8
                                duration: 1000
                                easingCurve: StockCurve.DoubleElasticOut
                            }
                            onEnded: {
                                reload();
                            }
                        }
                    ]
                    attachedObjects: [
                        MediaPlayer {
                            id: playerCorrect
                            sourceUrl: "sounds/correct_sound.mp3"
                        }
                    ]
                }
            }
            ProgressIndicator {
                id: timeRemaining
                toValue: 100.0
                value: 100.0
                scaleY: 2
                scaleX: 2
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Top
            }
        }
    }
    function assignData() {
        var val1 = index;
        var val2 = index;
        var val3 = index;
        var val4 = index;

        index = Math.ceil(Math.random() * (lista.length - 1));

        while (val1 == index) {
            val1 = Math.ceil(Math.random() * (lista.length));
            val1 --;
        }

        while ((val2 == index) || (val2 == val1)) {
            val2 = Math.ceil(Math.random() * (lista.length));
            val2 --;
        }

        while ((val3 == index) || (val3 == val1) || (val3 == val2)) {
            val3 = Math.ceil(Math.random() * (lista.length));
            val3 --;
        }

        while ((val4 == index) || (val4 == val1) || (val4 == val2) || (val4 == val3)) {
            val4 = Math.ceil(Math.random() * (lista.length));
            val4 --;
        }

        imageView.imageSource = "asset:///images/animals/" + lista[index].imageName;

        lbl1.text = lista[index].backgroundSound;
        lbl2.text = lista[val1].backgroundSound ;
        lbl3.text = lista[val2].backgroundSound ;
        lbl4.text = lista[val3].backgroundSound ;
        lbl5.text = lista[val4].backgroundSound ;

        playerAnimal.sourceUrl = "sounds/" + lista[index].animalSound;
    }

    function reload() {
        assignData();
        imgCorrect.opacity = 0;
        imageView.opacity = 1;
        lbl1.opacity = 1;
        lbl2.opacity = 1;
        lbl3.opacity = 1;
        lbl4.opacity = 1;
        lbl5.opacity = 1;
        timeRemaining.value = 200;
    }

    function loadXML() {
        var xmlContents = XML.LoadXML(appContext.currentDir() + "/app/native/assets/xml/data.xml");
        lista = xmlContents;

    }

    onCreationCompleted: {
        //translateAnimation.play();

        if (DisplayInfo.width > DisplayInfo.height) {
            width = DisplayInfo.width;
            height = DisplayInfo.height;
        } else {
            width = DisplayInfo.height;
            height = DisplayInfo.width;
        }

        loadXML();
        assignData();

        gameTimer.start();

        imageView.imageSource = "asset:///images/animals/" + lista[index].imageName;

        translateAnimation.toX = Math.ceil(Math.random() * (width - handler1.layoutFrame.width));
        translateAnimation.toY = Math.ceil(Math.random() * (height - handler1.layoutFrame.height - 80));
        translateAnimation.duration = 0;
        translateAnimation.play();

        translateAnimation2.toX = Math.ceil(Math.random() * (width - handler2.layoutFrame.width));
        translateAnimation2.toY = Math.ceil(Math.random() * (height - handler2.layoutFrame.height - 80));
        translateAnimation2.duration = 0;
        translateAnimation2.play();

        translateAnimation3.toX = Math.ceil(Math.random() * (width - handler3.layoutFrame.width));
        translateAnimation3.toY = Math.ceil(Math.random() * (height - handler3.layoutFrame.height - 80));
        translateAnimation3.duration = 0;
        translateAnimation3.play();

        translateAnimation4.toX = Math.ceil(Math.random() * (width - handler4.layoutFrame.width));
        translateAnimation4.toY = Math.ceil(Math.random() * (height - handler4.layoutFrame.height - 80));
        translateAnimation4.duration = 0;
        translateAnimation4.play();

        translateAnimation5.toX = Math.ceil(Math.random() * (width - handler5.layoutFrame.width));
        translateAnimation5.toY = Math.ceil(Math.random() * (height - handler5.layoutFrame.height - 80));
        translateAnimation5.duration = 0;
        translateAnimation5.play();
    }
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            title: "Back"
            onTriggered: {
                gameTimer.stop();
                navigationPane.pop();
            }
        }
    }
}
