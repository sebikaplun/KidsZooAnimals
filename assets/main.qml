// Navigation pane project template
import bb.cascades 1.0

NavigationPane {
    peekEnabled: false
    id: navigationPane
    property Page playPage
    function startGame(){
        playPage.startGame();
    }
    
    Page {
        // page with a picture thumbnail
        Container {
            background: Color.Black
            layout: AbsoluteLayout {
            }
            ImageView {
                imageSource: "asset:///background.jpg"
            }
            ImageView {
                imageSource: "asset:///ari.png"

                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 140
                    positionY: 30
                }
            }

            ImageView {
                imageSource: "asset:///learnbutton.png"

                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 850
                    positionY: 80
                }
                onTouch: {
                    // show detail page when the button is clicked
                    var page = getlearnPage();
                    console.debug("pushing detail " + page)
                    navigationPane.push(page);
                }
                property Page learnPage
                function getlearnPage() {
                    if (! learnPage) {
                        learnPage = learnPageDefinition.createObject();
                    }
                    return learnPage;
                }

                attachedObjects: [
                    ComponentDefinition {
                        id: learnPageDefinition
                        source: "learnPage.qml"
                    }

                ]
            }

            ImageView {
                imageSource: "asset:///playbutton.png"

                layoutProperties: AbsoluteLayoutProperties {
                    positionX: 850
                    positionY: 190
                }
                onTouch: {
                    // show detail page when the button is clicked
                    if (! playPage) {
                        playPage = getplayPage();
                    }
                    console.debug("pushing detail " + playPage)
                    navigationPane.push(playPage);
                    playPage.startGame();
                }
                function getplayPage() {
                    if (! playPage) {
                        playPage = playPageDefinition.createObject();
                    }
                    return playPage;
                }
                attachedObjects: [

                    ComponentDefinition {
                        id: playPageDefinition
                        source: "playPage.qml"
                    }
                ]
            }
        }
    }
    onCreationCompleted: {
        // this slot is called when declarative scene is created
        // write post creation initialization here
        //console.log("NavigationPane - onCreationCompleted()");

        // enable layout to adapt to the device rotation
        // don't forget to enable screen rotation in bar-bescriptor.xml (Application->Orientation->Auto-orient)
        //OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.All;
    }

    onPopTransitionEnded: {
        //playPage.startGame();
    }

}
