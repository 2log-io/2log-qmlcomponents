import QtQuick 2.5
import QtQuick.Layouts 1.3
import UIControls 1.0

BaseItem
{
    id: docroot
    height: 240
    width: 240

    property string icon: Icons.lasercutter
    signal clicked()
    property string deviceName
    property int deviceState
    property string iconImage
    property string currentUser
    property int readyState: 0
    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10


        Item
        {
            width: 56
            height: 56
            Layout.alignment:Qt.AlignCenter

            Icon
            {
                id: icon
                icon: docroot.icon
                iconSize: 56
                iconColor: "white"
                opacity: .4
                visible: docroot.iconImage == undefined || docroot.iconImage == ""
            }

            Image
            {
                id: iconImage
                anchors.fill: parent
                sourceSize.width: parent.width
                sourceSize.height: parent.height
                source: docroot.iconImage === "" ? "" :  "qrc:/"+docroot.iconImage
            }

            InfoBubble
            {
                id: bubble
                visible: false
                anchors.top: parent.bottom
                anchors.left: parent.right
                anchors.topMargin:  -15
                anchors.leftMargin: 0
            }


            LogoSpinner
            {
                id: spinner
                visible: false
                anchors.top: parent.bottom
                anchors.left: parent.right
                anchors.topMargin:  -15
                anchors.leftMargin: 0
                size: 22

            }

        }


        Item
        {
            height: 40
            Layout.fillWidth: true
            Layout.alignment:Qt.AlignBottom

            Column
            {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter

                TextLabel
                {
                    text:docroot.deviceName
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    fontSize: Fonts.controlFontSize
                    wrapMode: Text.Wrap

                    //anchors.horizontalCenter: parent.horizontalCenter
                }

                TextLabel
                {
                    text:docroot.currentUser
                    fontSize: Fonts.smallControlFontSize
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked: docroot.clicked()
    }

    states:
    [
        State
        {
            name:"active"
            when: docroot.deviceState === 1
            PropertyChanges
            {
                target: icon
                opacity: 1
            }

            PropertyChanges
            {
                target: bubble
                visible: true
                icon: Icons.user
            }
        },
        State
        {
            name:"running"
            when: docroot.deviceState === 2
            PropertyChanges
            {
                target: icon
                opacity: 1
            }

            PropertyChanges
            {
                target: bubble
                visible: false
                icon: Icons.running
            }

            PropertyChanges
            {
                target: spinner
                visible: true
            }
        },
        State
        {
            name:"error"
            when: docroot.readyState < 0
            PropertyChanges
            {
                target: bubble
                visible: true
                icon: Icons.offline
                infoColor: Colors.warnRed
            }
        }
    ]
}
