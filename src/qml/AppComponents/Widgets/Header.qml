import QtQuick 2.5
import UIControls 1.0
import QtQuick.Layouts 1.3
import CloudAccess 1.0

Item {
    id: docroot

    default property alias content: row.children
    signal userButtonClicked
    property alias leftSide: lhsLayout.children
    height: 50

    Rectangle {
        anchors.fill: parent
        color: Colors.greyBlue
    }

    Item {
        height: parent.height
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter

        Row {
            id: row
            spacing: 0
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
        }

        Row {
            id: lhsLayout
            height: parent.height
            anchors.right: parent.right
        }
    }
}
