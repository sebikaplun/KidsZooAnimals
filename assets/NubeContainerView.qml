import bb.cascades 1.0

Container {
    property alias text: labelAnimal.text

    Container {

        layout: DockLayout {
        }
        ImageView {
            imageSource: "asset:///nube.png"
            
        }
        Label {
            id: labelAnimal
            //textStyle.base: myStyle.style
            textStyle.fontSize: FontSize.XXLarge
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            textStyle.color: Color.Black
        }
    }
}
