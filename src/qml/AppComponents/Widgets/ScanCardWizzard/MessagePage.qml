import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import UIControls 1.0

Item
{

    id: docroot

    property string icon: Icons.info
    property bool active: (StackView.status == StackView.Active) && parentStackActive
    property string message
    property color iconColor: Colors.highlightBlue
    signal confirm
    signal cancel

    Row
    {
        id: layout
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -20
        width: parent.width > 500 ? 500 : parent.width


        Icon
        {
            id: icon
            icon: docroot.icon
            iconColor: docroot.iconColor
            width: 80
            height: 40
            iconSize: 32
            anchors.verticalCenter: parent.verticalCenter
        }

        TextLabel
        {
            width: layout.width -80
            fontSize: 18
            wrapMode: Text.WordWrap
            text: docroot.message
        }

    }

    StandardButton
    {
        transparent: true
        icon: Icons.leftAngle
        text: qsTr("Abbrechen")
        anchors.bottom: parent.bottom
        onClicked: docroot.cancel()
        opacity: docroot.active ? 1 : 0

        Behavior on opacity
        {
            NumberAnimation{ }
        }
    }
}
