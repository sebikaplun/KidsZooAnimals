import bb.cascades 1.0

Dialog
{
    id: gameDialog
    
	signal mainButtonClick()
    signal secondButtonClick()
    property alias title:lbl1.text
	property alias subtitle:lbl2.text
	property alias upBbuttonText:mainButton.text
    property alias downBbuttonText: secondButton.text

    function start()
	{
	    dialogInAnimation.play()
	}
	function end()
	{
	    dialogOutAnimation.play()
	}
	
	Container
	{
		background: Color.create(0.0, 0.0, 0.0, 0.5)
		layout: DockLayout {}
		Container {
			maxHeight: 900.0
			maxWidth: 700.0
			horizontalAlignment: HorizontalAlignment.Center
			verticalAlignment: VerticalAlignment.Center
			
			animations:
			[
				TranslateTransition
				{
					id: dialogOutAnimation
					toY: -850
					duration: 500
					onEnded:
					{
						gameDialog.close()
					}
				},
				TranslateTransition
				{
					id: dialogInAnimation
					toY: -850
					duration: 0
					easingCurve: StockCurve.QuadraticInOut
					onEnded:
					{
						gameDialog.open()
						dialogSlideInAnimation.play()
					}
				},
				TranslateTransition
				{
					id: dialogSlideInAnimation
					toY: 0
					duration: 500
					easingCurve: StockCurve.QuadraticInOut
				}
			]
			
			layout: DockLayout {}
			ImageView {
				imageSource: "asset:///images/DialogBackGr.png"
			}
			Container {
			    translationY: 40
			    layout: StackLayout {
           
           		}
				horizontalAlignment: HorizontalAlignment.Center
				Label {
                    text: "Level 1 Completed"
                    id: lbl1
					textStyle.fontWeight: FontWeight.Bold
					textStyle.fontSize: FontSize.XLarge
					horizontalAlignment: HorizontalAlignment.Center
					textStyle.color: Color.White
				}
				Label {
				    id: lbl2
				    text :"Tu puntaje fue de 100 puntos"
					multiline: true
                    textStyle.fontSize: FontSize.Large
                    textStyle.color: Color.Black
					horizontalAlignment: HorizontalAlignment.Center
				}

				Button {
					id: mainButton
					onClicked: {
					    mainButtonClick();
					}
					horizontalAlignment: HorizontalAlignment.Center
				}
                Button {
                    id: secondButton
                    onClicked: {
                        secondButtonClick();
                    }
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
		}

		verticalAlignment: VerticalAlignment.Fill
		horizontalAlignment: HorizontalAlignment.Fill
	}
}