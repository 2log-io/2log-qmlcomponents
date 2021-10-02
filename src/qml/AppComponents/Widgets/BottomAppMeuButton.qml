import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import UIControls 1.0

Item
{
    id: docroot
    property string text
    property string icon
    property bool selected

    signal clicked()

    Layout.fillHeight: true
    Layout.fillWidth: true
    height: 40

    Column
    {
        spacing: 6
        anchors.centerIn: parent
        Icon
        {

            icon: docroot.icon
            iconColor:docroot.selected ? Colors.highlightBlue : Colors.lightGrey
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TextLabel
        {
            fontSize: Fonts.verySmallControlFontSize
            text: docroot.text
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            docroot.clicked()
        }
    }
}
