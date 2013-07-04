import bb.cascades 1.0
import bb.system 1.0

Page {
    id: topLeaderboardPage
    objectName: "leaderboardpage"
    property int dialogShow: 0
    Container {
        background: back.imagePaint
        attachedObjects: [
            ImagePaintDefinition {
                id: back
                imageSource: "asset:///background.jpg"
            }
        ]
        horizontalAlignment: HorizontalAlignment.Center
        Container {

            background: Color.create("#4a4a4a")
            horizontalAlignment: HorizontalAlignment.Fill
            Container {
                leftPadding: 25
                Label {
                    text: "Leaderboard"
                    horizontalAlignment: HorizontalAlignment.Left
                    textStyle {
                        base: SystemDefaults.TextStyles.BigText
                        color: Color.create("#00A8DF")
                    }
                }
            }
        }
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            layout: DockLayout {
            }
            ActivityIndicator {
                id: loader
                preferredHeight: 500
                preferredWidth: 500
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }
            ListView {
                id: leaderboardList
                dataModel: GroupDataModel {
                    id: leaderboardModel
                    grouping: ItemGrouping.None
                    sortingKeys: [ "rank" ]
                }
                visible: false
                listItemComponents: [
                    ListItemComponent {
                        type: "item"
                        content: Container {
                            background: Color.create(152, 149, 149, 30)
                            Container {
                                layout: StackLayout {
                                    orientation: LayoutOrientation.LeftToRight
                                }
                                preferredHeight: 60
                                Label {
                                    text: ListItemData.rank
                                    textStyle.base: SystemDefaults.TextStyles.TitleText
                                    textStyle.textAlign: TextAlign.Center
                                    preferredWidth: 150
                                    verticalAlignment: VerticalAlignment.Center
                                    horizontalAlignment: HorizontalAlignment.Left
                                }
                                Container {
                                    layout: StackLayout {
                                        orientation: LayoutOrientation.LeftToRight
                                    }
                                    horizontalAlignment: HorizontalAlignment.Left
                                    verticalAlignment: VerticalAlignment.Center
                                    Container {
                                        Label {
                                            text: ListItemData.username
                                            textStyle.base: SystemDefaults.TextStyles.TitleText
                                        }
                                        layoutProperties: StackLayoutProperties {
                                            spaceQuota: 1
                                        }
                                    }
                                    Container {
                                        rightPadding: 10
                                        Label {
                                            text: ListItemData.simpleScore + " points"
                                            textStyle.base: SystemDefaults.TextStyles.TitleText
                                        }
                                    }
                                }
                            }
                            Divider {
                            }
                        }
                    }
                ]
            }
        }

        /* onCreationCompleted: {
         * loader.start()
         * appContext.scoreLoop().LoadLeaderboardCompleted.connect(topLeaderboardPage.handleLeaderboard)
         * appContext.onInformLeaderboardFail.connect(topLeaderboardPage.scoreLoopError);
         * appContext.loadLeaderboard("all-time", 100) //change to "24-hour" for a leaderboard of the past 24 hours
         * }*/
    }

    function startPage() {
        loader.start()
        appContext.scoreLoop().LoadLeaderboardCompleted.connect(topLeaderboardPage.handleLeaderboard)
        appContext.onInformLeaderboardFail.connect(topLeaderboardPage.scoreLoopError);
        appContext.onInformLoadingdFail.connect(topLeaderboardPage.loading);
        appContext.loadLeaderboard("all-time", 100) //change to "24-hour" for a leaderboard of the past 24 hours
    }

    function loading() {
        console.log("scoreloop not ready")
        loadingTimer.start();
        loadingToast.show();
    }

    function handleLeaderboard(leaderboardData) {
        loader.stop()
        console.log("scoreloop loading OK");
        leaderboardModel.clear();
        loader.visible = false
        leaderboardList.visible = true
        leaderboardModel.insertList(leaderboardData)
    }

    function scoreLoopError(leaderboardData) {
        console.log("scoreloop error " + dialogShow)
        if (dialogShow == 0) {
            //console.log("imprimio")
            dialogShow = 1;
            myQmlDialog.show();
            // loading();
        }

    }

    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            title: "Back"
            onTriggered: {
                dialogShow = 0;
                navigationPane.pop();
                navigationPane.startGame();
            }
        }
    }
    attachedObjects: [
        SystemDialog {
            id: myQmlDialog
            title: qsTr("Connection fail")
            body: qsTr("Press OK to continue in application, Cancel to quit")
            confirmButton.label: "Cancel"
            confirmButton.enabled: true
            cancelButton.label: "OK"
            cancelButton.enabled: true
            onFinished: {
                var x = result;
                //console.log(myQmlDialog.error);
                if (x == SystemUiResult.ConfirmButtonSelection) {
                    Application.quit();
                    console.log("confirm");
                    dialogShow = 0;
                } else if (x == SystemUiResult.CancelButtonSelection) {
                    navigationPane.pop();
                    navigationPane.startGame();
                    dialogShow = 0;
                    myQmlDialog.confirmButton.label
                    console.log("cancel");
                }
            }
        },
        SystemProgressToast {
            id: loadingToast
            body: "Connecting with the server"
            statusMessage: "loading..."
            state: SystemUiProgressState.Error
            position: SystemUiPosition.MiddleCenter
            progress: 100
            onProgressChanged: {
                if (loadingToast.progress == -1) {
                    loadingTimer.stop();
                    startPage();
                    console.log("scoreloop starting");
                }
            }
        },
        QTimer {
            id: loadingTimer
            interval: 50
            onTimeout: {
                //console.log(loadingToast.progress)
                loadingToast.progress -= 1;
                loadingToast.show();
                //console.log(loadingToast.progress)
                if (loadingToast.progress == 0) {
                    loadingToast.progress = -1;
                }
                /* raiseAnimationLost.play();
                 * fade1.play();
                 * fade2.play();
                 * fade3.play();
                 * fade4.play();
                 * fade5.play();
                 * fadeImage.play();
                 * gameTimer.stop();*/
            }
        }
    ]
    onCreationCompleted: {
        myQmlDialog.confirmButton.label = "Yes";
        myQmlDialog.cancelButton.label = "No";

        console.log(myQmlDialog.confirmButton.label);
        console.log("on creatioooon")
    }
}
