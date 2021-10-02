import QtQuick 2.5
import UIControls 1.0

Rectangle
{
    id: docroot

    signal clicked()

    property alias icon: icon.icon
    property alias text: text.text
    property alias fontColor: text.color
    property bool checkable: false
    property bool checked: false

    width: layout.width
    height: 35
    color: "transparent"
    radius: 2


    Row
    {
        id: layout
        height: parent.height
        anchors.centerIn: parent
        spacing: 10
        opacity: .6

        Icon
        {
            id: icon
            iconColor: Colors.white
            anchors.verticalCenter: parent.verticalCenter
            width: 16
            height: 16
            visible: icon.icon !== ""
            iconSize: 14
        }

        Text
        {
            id: text
            color: Colors.white
            text:docroot.text
            font.pixelSize: Fonts.smallControlFontSize
            anchors.verticalCenter: parent.verticalCenter
            font.family: Fonts.simplonNorm_Medium
        }
    }

    MouseArea
    {
       id: mouseArea
       anchors.fill: parent
       onClicked: docroot.clicked()
       hoverEnabled: true
    }

    Item
    {
        states:
        [
            State
            {
                name:"disabled"
                when:!docroot.enabled
                PropertyChanges
                {
                    target: docroot
                    opacity: .3
                }
            },
            State
            {
                name:"pressed"
                when: mouseArea.pressed

                PropertyChanges
                {
                    target: layout
                    opacity: 1
                }
            },
            State
            {
                name:"hover"
                when: mouseArea.containsMouse
                PropertyChanges
                {
                    target: layout
                    opacity: 1
                }
            }
        ]

        transitions:
        [
            Transition
            {
                from: "pressed"
                to:"hover"

                NumberAnimation
                {
                    property: "opacity"
                }

                ColorAnimation {
                    target: docroot
                    duration: 200
                }
            },

            Transition
            {
                from: "hover"
                to:""

                NumberAnimation
                {
                    property: "opacity"
                }

                ColorAnimation
                {
                    target: docroot
                    duration: 200
                }
            }
        ]
    }
}
