// Default empty project template
import bb.cascades 1.0
import bb.data 1.0
import bb.multimedia 1.0
// creates one page with a label
Page {
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
        }
    ]
    property variant lista: []
    property int index: 0
    property int width
    property int height
    property int timeToAnimate: 0
    property int isPlaying: 0
    onCreationCompleted: {
        var xmlContents = XML.LoadXML(appContext.currentDir() + "/app/native/assets/xml/data.xml");
        lista = xmlContents;
        imageView.imageSource = "asset:///images/animals/" + lista[index].imageName;
        imageViewRight.imageSource = "asset:///images/animals/" + lista[index + 1].imageName;
        imageViewLeft.imageSource = "asset:///images/animals/" + lista[lista.length - 1].imageName; //ACA HAY QUE CAMBIAR CON EL LENGHT

        lblMain1.text = lista[index].backgroundSound ;

        player.sourceUrl = "sounds/" + lista[index].animalSound;
        playerAnimal.sourceUrl = "sounds/" + lista[index].pressedSound;
        player.play();

        if (DisplayInfo.width > DisplayInfo.height) {
            width = DisplayInfo.width;
            height = DisplayInfo.height;
        } else {
            width = DisplayInfo.height;
            height = DisplayInfo.width;
        }
    }

    Container {
        horizontalAlignment: HorizontalAlignment.Center
        layout: DockLayout {
        }

        Container {
            id: slideContainer
            property variant xOrigin
            property variant xLast
            property variant move: 0
            layout: DockLayout {
            }
            onTouch: {
                if (event.isDown()) {
                    console.log("Entro a down ", event.localX);
                    xOrigin = event.localX;
                    xLast = event.localX;
                } else if (event.isMove()) {
                    console.log("Entro a move ", event.localX);
                    move = 1;
                    if (((event.localX - xOrigin) > 10) || ((xOrigin - event.localX) > 10)) {
                        if (event.localX > xOrigin) {
                            slideLayout.translationX = event.localX - xOrigin;
                            slideLayoutLeft.translationX = ((event.localX - xOrigin) * 1.45) - width;
                            slideLayout.opacity = event.localX / width;
                            xLast = event.localX;
                            if (slideLayoutLeft.translationX > 0) {
                                slideLayoutLeft.translationX = 0;
                            }
                        } else {

                            slideLayout.translationX = event.localX - xOrigin
                            slideLayoutRight.translationX = width + ((event.localX - xOrigin) * 1.45)
                            slideLayout.opacity = event.localX / width;
                            xLast = event.localX;

                            if (slideLayoutRight.translationX < 0) {
                                slideLayoutRight.translationX = 0;
                            }
                        }
                    }
                } else if (event.isUp()) {
                    console.log("Entro up", event.localX);
                    if (event.localX > xOrigin) {
                        if ((move == 1) & ((event.localX - xOrigin) > 20)) {
                            if (event.localX > xLast) {
                                timeToAnimate = slideLayoutLeft.translationX / 2
                                finishAnimationLeft.play();
                                slideLayout.opacity = 255;
                            } else {
                                slideLayoutLeft.translationX = - width;
                                slideLayout.opacity = 1;
                                slideLayout.translationX = 0;
                            }
                        } else {
                            slideLayoutLeft.translationX = - width;
                            slideLayout.opacity = 1;
                            slideLayout.translationX = 0;
                        }
                    } else {
                        console.log(move);
                        if ((move == 1) & ((xOrigin - event.localX) > 20)) {
                            if (event.localX < xLast) {
                                timeToAnimate = slideLayoutRight.translationX / 2
                                finishAnimationRight.play();
                                slideLayout.opacity = 255;
                            } else {
                                slideLayoutRight.translationX = width;
                                slideLayout.opacity = 1;
                                slideLayout.translationX = 0;
                            }
                        }
                    }
                    move:
                    0;
                }
            }
            Container {
                id: slideLayout
                layout: DockLayout {
                }
                ImageView {
                    id: imageView
                    imageSource: ""
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    onTouch: {
                        if (event.isUp()) {
                            if (isPlaying == 0) {
                                isPlaying = 1;
                            }

                        }
                    }
                }
                ImageView {
                    id: imageViewPlay
                    imageSource: "asset:///unnamed.png"
                    horizontalAlignment: HorizontalAlignment.Right
                    verticalAlignment: VerticalAlignment.Top
                    preferredHeight: 150
                    preferredWidth: 200
                    onTouch: {
                        playerAnimal.play();
                    }
                }

                ImageView {
                    imageSource: "asset:///nube-bottom.png"
                    verticalAlignment: VerticalAlignment.Bottom
                    horizontalAlignment: HorizontalAlignment.Center
                }
                Label {
                    id: lblMain1
                    textStyle.fontSize: FontSize.XXLarge
                    textStyle.color: Color.Black
                    verticalAlignment: VerticalAlignment.Bottom
                    horizontalAlignment: HorizontalAlignment.Center
                    bottomMargin: 20
                    onTouch: {
                        player.play();
                    }
                }

                animations: [
                    TranslateTransition {
                        toX: width
                        duration: 500
                        easingCurve: StockCurve.QuadraticInOut
                        id: moveingToRight
                        onEnded: {
                            if (index == 0) {
                                index = lista.length;
                            }
                            index = index - 1;
                            imageView.imageSource = "asset:///images/animals/" + lista[index].imageName;
                            lblMain1.text = lista[index].backgroundSound;
                            moveingFromRight.play();
                        }
                    },
                    TranslateTransition {
                        fromX: - width
                        toX: 0
                        easingCurve: StockCurve.QuadraticInOut
                        duration: 0
                        id: showActualImage
                    },
                    TranslateTransition {
                        toX: - width
                        duration: 500
                        easingCurve: StockCurve.QuadraticInOut
                        id: moveingToLeft
                        onEnded: {
                            if (index == lista.length - 1) {
                                index = -1;
                            }
                            index = index + 1;
                            imageView.imageSource = "asset:///images/animals/" + lista[index].imageName;
                            lblMain1.text = lista[index].backgroundSound ;

                            moveingFromLeft.play();
                        }
                    },
                    TranslateTransition {
                        fromX: width
                        easingCurve: StockCurve.QuadraticInOut
                        toX: 0
                        duration: 500
                        id: moveingFromLeft
                    }
                ]
                attachedObjects: [
                    MediaPlayer {
                        id: player
                        sourceUrl: "sounds/2317830.mp3"
                        onPlaybackCompleted: {

                        }
                    },
                    MediaPlayer {
                        id: playerAnimal
                        sourceUrl: "sounds/2317830.mp3"
                    }
                ]
            }
            Container {
                id: slideLayoutLeft
                layout: DockLayout {
                }
                translationX: - width
                ImageView {
                    id: imageViewLeft
                    imageSource: ""
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                }
                Label {
                    id: lblLeft
                    textStyle.base: SystemDefaults.TextStyles.BigText
                    verticalAlignment: VerticalAlignment.Bottom
                    horizontalAlignment: HorizontalAlignment.Center
                    bottomMargin: 20
                }
                animations: [
                    TranslateTransition {
                        toX: 0
                        duration: timeToAnimate
                        easingCurve: StockCurve.QuadraticInOut
                        id: finishAnimationLeft
                        onEnded: {
                            if (index == 0) {
                                index = lista.length; //ACA FALTA EL LENGHT
                            }
                            index = index - 1;
                            imageView.imageSource = "asset:///images/animals/" + lista[index].imageName;
                            lblMain1.text = lista[index].backgroundSound;

                            hideConteinerLeft.play();
                            showActualImage.play();
                        }
                    },
                    TranslateTransition {
                        toX: - width
                        easingCurve: StockCurve.QuadraticInOut
                        duration: 0
                        id: prepareNextLeft
                        onEnded: {
                            console.log(lista.lengtt);
                            player.sourceUrl = "sounds/" + lista[index].animalSound;
                            playerAnimal.sourceUrl = "sounds/" + lista[index].pressedSound;
                            player.play();

                            if (index == 0) {
                                imageViewLeft.imageSource = "asset:///images/animals/" + lista[lista.length - 1].imageName; //ACA FALTA LENGHT
                                //lblLeft.text = lista[lista.length - 1].backgroundSound;
                            } else {
                                imageViewLeft.imageSource = "asset:///images/animals/" + lista[index - 1].imageName;
                                //lblLeft.text = lista[index - 1].backgroundSound;
                            }
                            if (index == lista.length) { ///ESTO HAY QUE CAMBIARLO CON ALGO COMO LISTA.LENGHT-1 PERO NO FUNCIONA
                                imageViewRight.imageSource = "asset:///images/animals/" + lista[0].imageName;
                                //lblRight.text = lista[0].backgroundSound;
                            } else {
                                imageViewRight.imageSource = "asset:///images/animals/" + lista[index + 1].imageName;
                                //lblRight.text = lista[index + 1].backgroundSound;
                            }

                            slideLayoutLeft.opacity = 255;
                        }
                    },
                    FadeTransition {
                        toOpacity: 0
                        id: hideConteinerLeft
                        duration: 0
                        onEnded: {
                            prepareNextLeft.play();
                        }
                    }
                ]
            }

            Container {
                id: slideLayoutRight
                layout: DockLayout {
                }
                translationX: width
                ImageView {
                    id: imageViewRight
                    imageSource: ""
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                }
                Label {
                    id: lblRight
                    textStyle.base: SystemDefaults.TextStyles.BigText
                    verticalAlignment: VerticalAlignment.Bottom
                    horizontalAlignment: HorizontalAlignment.Center
                    bottomMargin: 20
                }
                animations: [
                    TranslateTransition {
                        toX: 0
                        duration: timeToAnimate
                        easingCurve: StockCurve.QuadraticInOut
                        id: finishAnimationRight
                        onEnded: {
                            if (index == lista.length - 1) {
                                index = -1;
                            }
                            index = index + 1;
                            imageView.imageSource = "asset:///images/animals/" + lista[index].imageName;
                            lblMain1.text = lista[index].backgroundSound;

                            hideConteinerRight.play();
                            showActualImage.play();
                        }
                    },
                    TranslateTransition {
                        toX: width
                        easingCurve: StockCurve.QuadraticInOut
                        duration: 0
                        id: prepareNextRight
                        onEnded: {
                            player.sourceUrl = "sounds/" + lista[index].animalSound;
                            playerAnimal.sourceUrl = "sounds/" + lista[index].pressedSound;
                            player.play();

                            if (index == lista.length - 1) { ///ESTO HAY QUE CAMBIARLO CON ALGO COMO LISTA.LENGHT-1 PERO NO FUNCIONA
                                imageViewRight.imageSource = "asset:///images/animals/" + lista[0].imageName;
                                //lblRight.text = lista[0].backgroundSound;
                            } else {
                                imageViewRight.imageSource = "asset:///images/animals/" + lista[index + 1].imageName;
                                //lblRight.text = lista[index + 1].backgroundSound;
                            }

                            if (index == 0) {
                                imageViewLeft.imageSource = "asset:///images/animals/" + lista[lista.length - 1].imageName; //ACA FALTA LENGHT
                                //lblLeft.text = lista[lista.length - 1].backgroundSound;
                            } else {
                                imageViewLeft.imageSource = "asset:///images/animals/" + lista[index - 1].imageName;
                                //lblLeft.text = lista[index - 1].backgroundSound;
                            }

                            slideLayoutRight.opacity = 255;
                        }
                    },
                    FadeTransition {
                        toOpacity: 0
                        id: hideConteinerRight
                        duration: 0
                        onEnded: {
                            prepareNextRight.play();
                        }
                    }
                ]
            }
        }
    }

}
