import QtQuick 2.5
import UIControls 1.0
import QtQuick.Layouts 1.3

Rectangle {
    id: docroot
    color: Colors.darkBlue //brighterDarkBlue
    default property alias content: content.children
    property int margins: 20
    radius: 0
    property int spacing: 20

    Item {
        id: content
        anchors.fill: parent
        anchors.margins: docroot.margins
    }

    Shadow {
        visible: docroot.color != "transparent"
    }
}
