import bb.cascades 1.0
import bb.multimedia 1.0
import bb.data 1.0

Page {
    property int time: 200
    property int timeMoving: 2000
    property variant lista: []
    function startGame() {
        gameTimer.start();
    }
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
            }
        ]

        Container {
            id: gameContainer
            layout: DockLayout {
            }

            Container {
                id: gameLayout
                layout: StackLayout {

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
                            //console.log(timeRemaining);
                            if (timeRemaining.value == 0) {
                                randomSound();
                                timeRemaining.value = 100;
                            }
                        }
                    }
                ]

                ImageView {
                    id: playSound
                    imageSource: "asset:///unnamed.png"
                    scalingMethod: ScalingMethod.Fill
                    minHeight: 150;
                    minWidth: 1280
                    horizontalAlignment: HorizontalAlignment.Center
                    onTouch: {
                        playerAnimal.play();
                    }
                }
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    ImageView {
                        id: image1
                        imageSource: "asset:///images/animals/bear.jpg"
                        scalingMethod: ScalingMethod.AspectFill
                    }
                    ImageView {
                        id: image2
                        imageSource: "asset:///images/animals/beaver.jpg"
                        scalingMethod: ScalingMethod.AspectFill
                    }
                    ImageView {
                        id: image3
                        imageSource: "asset:///images/animals/bee.jpg"
                        scalingMethod: ScalingMethod.AspectFill
                    }
                }
            }
            ProgressIndicator {
                id: timeRemaining
                toValue: 100.0
                value: 100.0
                minWidth: 1280
                minHeight: 200
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Top
            }
        }
    }
    onCreationCompleted: {
        startGame();
        loadXML();
        randomSound();
    }

    function randomSound() {
        var realVerdadero = Math.ceil(Math.random() * lista.length);
        var false1 = Math.ceil(Math.random() * lista.length);
        while (false1 == realVerdadero) {
            false1 = Math.ceil(Math.random() * lista.length);
        }
        var false2 = Math.ceil(Math.random() * lista.length);
        while (false2 == realVerdadero == false1) {
            false2 = Math.ceil(Math.random() * lista.length);
        }
        console.log(realVerdadero);
        console.log(false1);
        console.log(false2);

        image1.imageSource = "asset:///images/animals/" + lista[realVerdadero].imageName;
        image2.imageSource = "asset:///images/animals/" + lista[false1].imageName;
        image3.imageSource = "asset:///images/animals/" + lista[false2].imageName;

        playerAnimal.sourceUrl = "sounds/" + lista[realVerdadero].pressedSound;

    }

    function loadXML() {
        var xmlContents = XML.LoadXML(appContext.currentDir() + "/app/native/assets/xml/data.xml");
        lista = xmlContents;

    }

}
