import QtQuick 2.5
import UIControls 1.0
import QtQuick.Controls 2.5 as QtControls
import QtQuick.Layouts 1.1
import "../"

QtControls.Container
{
    id: docroot
    height: totalHeight

    property alias header: headerSpace.children
    property alias tabButtons: row.children


    contentItem:
    Item
    {
        id: content
        anchors.fill: parent

        ColumnLayout
        {
            anchors.fill: parent
            spacing: 0

            Item
            {
                height: 40
                Layout.fillWidth: true
                z: 10

                Rectangle
                {
                    anchors.fill: parent
                    color: Colors.greyBlue
                    opacity: 1
                    Shadow
                    {
                        property bool shadowTop: false
                        property bool shadowRight: false
                        property bool shadowLeft: false
                    }
                }

                Row
                {
                    id: row
                    height: 35
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 5

                    Repeater
                    {
                        model: docroot.count
                        TabButton
                        {
                            checkable: false
                            text: docroot.itemAt(index).text
                            checked: list.currentIndex === index
                            onClicked:list.positionViewAtIndex(index, ListView.Center)
                        }
                    }

                }

                Row
                {
                    id: headerSpace
                    height: parent.height
                    anchors.right: parent.right
                }
            }


            ContainerBase
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                margins: 0

                ListView
                {
                    id: list
                    clip: true
                    snapMode: ListView.SnapOneItem
                    orientation: ListView.Horizontal
                    anchors.fill: parent
                    anchors.margins: 20
                    model: docroot.contentModel
                    preferredHighlightBegin: 0
                    preferredHighlightEnd: 1
                    onCurrentIndexChanged: console.log(currentIndex)
                    highlightRangeMode: ListView.StrictlyEnforceRange
                }
            }
        }
    }
}
