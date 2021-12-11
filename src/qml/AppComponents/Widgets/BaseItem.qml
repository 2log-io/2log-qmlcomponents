import QtQuick 2.5
import UIControls 1.0

Rectangle {
    id: docroot

    property color borderColor: "transparent" //Colors.greyBlue
    property alias borderOpacity: border.opacity
    property alias backgroundColor: background.color
    property alias backgroundOpacity: background.opacity

    color: "transparent"

    Shadow {
        opacity: .05
    }

    Rectangle {

        id: border
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: docroot.borderColor
    }

    Rectangle {
        id: background
        anchors.fill: parent
        radius: 3
        color: Colors.white
        opacity: .03
    }
}
