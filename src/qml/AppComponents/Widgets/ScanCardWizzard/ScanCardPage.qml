import QtQuick 2.5
import CloudAccess 1.0
import QtQuick.Controls 2.3
import UIControls 1.0


Item
{
    id: scanCardPage

    property bool active: (StackView.status == StackView.Active) //&& parentStackActive

    signal confirm(string cardID)
    signal cancel()

    property CardReader reader
    Connections
    {
        target: reader
        onCardRead:
        {
            if(data.errorCode < 0)
            {
                scanCardPage.state = "cardOK"
            }
            else
            {
                scanCardPage.state = "cardUsed"
                console.log("Karte bereits verwendet")
            }
        }
    }

    Column
    {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -20
        spacing: 20

        Item
        {
            width:  30
            height: 30
            anchors.horizontalCenter: parent.horizontalCenter

            Icon
            {
                id: cardIccon
                anchors.centerIn: parent
                iconSize: 30
                icon: Icons.card

                SequentialAnimation
                {
                    id: animation
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation
                    {
                       from: 1
                       to: 1.2
                       property: "scale"
                       target: cardIccon
                       duration: 400

                    }
                    NumberAnimation
                    {
                        to: 1
                        property: "scale"
                        target: cardIccon
                        duration: 600
                    }
                }
            }

            Rectangle
            {
                id: bubble
                property color bubbleColor: Colors.highlightBlue
                property string bubbleIcon: Icons.check

                opacity: 0
                width: 22
                height: 22
                radius: 11
                border.color:  bubbleColor
                color: Colors.darkBlue
                anchors.horizontalCenter: parent.right
                anchors.verticalCenter: parent.bottom

                Icon
                {
                    iconSize: 10
                    iconColor: parent.bubbleColor
                    anchors.centerIn: parent
                    icon: bubble.bubbleIcon
                }
            }
        }

        TextLabel
        {
            id: cardField
            anchors.horizontalCenter: parent.horizontalCenter
            fontSize: Fonts.actionFontSize
            text: "Karte scannen"
            visible: opacity > 0
        }

        TextField
        {
            id: descriptionField
            centerPlaceholder: true
            anchors.horizontalCenter: parent.horizontalCenter
            visible: opacity > 0
            opacity:0
            fontSize: Fonts.actionFontSize
        }
    }

    StandardButton
    {
        transparent: true
        icon: Icons.leftAngle
        text: qsTr("Abbrechen")
        anchors.bottom: parent.bottom
        onClicked: scanCardPage.cancel()
        opacity: scanCardPage.active ? 1 : 0

        Behavior on opacity
        {
            NumberAnimation{ }
        }
    }

    Timer
    {
        id: confirmTimer
        interval: 1000
        onTriggered:
        {
            scanCardPage.confirm(reader.lastCardID)
        }

    }

    states:
    [
        State
        {
            name: "cardOK"
            PropertyChanges
            {
                target:  animation
                running: false
            }

            PropertyChanges
            {
                target:  cardIccon
                iconColor: Colors.white
                scale: 1.2
            }

            PropertyChanges
            {
                target:  bubble
                opacity: 1
            }

            PropertyChanges
            {
                target:  cardField
                opacity: 1
                text: reader.lastCardID
            }

            PropertyChanges
            {
                target:  descriptionField
                opacity: 0
                placeholderText: reader.lastCardID
            }

            StateChangeScript
            {
                script: confirmTimer.start()
            }


//            PropertyChanges
//            {
//                target: confirmButton
//                opacity:1
//            }
        },
        State
        {
            name: "cardUsed"
            PropertyChanges
            {
                target:  animation
                running: false
            }

            PropertyChanges
            {
                target:  cardIccon
                iconColor: Colors.white
                opacity: .5
                scale: 1
            }

            PropertyChanges
            {
                target:  bubble
                opacity: 1
                bubbleColor: Colors.warnRed
                bubbleIcon: Icons.warning
            }

            PropertyChanges
            {
                target:  cardField
                text: qsTr("Karte bereits registriert")
            }

//            PropertyChanges
//            {
//                target: confirmButton
//                opacity:0
//            }
        }
    ]

    transitions:
    [
        Transition
        {

            PropertyAction
            {
                target: cardField
                property:"text"
            }

            PropertyAction
            {
                 target: descriptionField
                 property:"placeholderText"
            }

            PropertyAction
            {
                 target: bubble
                 property:"bubbleColor"
            }


            PropertyAction
            {
                 target: bubble
                 property:"bubbleIcon"
            }

            ColorAnimation
            {
                target: cardIccon
            }

            NumberAnimation
            {
                property: "scale"
                target: cardIccon
                duration: 100
            }
        }
    ]
}
