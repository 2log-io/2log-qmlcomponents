import QtQuick 2.12

import CloudAccess 1.0
import QtQuick.Controls 2.3
import UIControls 1.0




Item
{
    id: docroot

    signal confirm(string cardID)
    signal cancel()

    property CardReader reader

    ServiceModel
    {
        id: labService
        service: "lab"
    }

    function callback(data)
    {
        if(data.errorCode < 0)
        {
            console.log("Unbekannte Karte")
            docroot.state = "cardOK"

        }
        else
        {
            docroot.state = "cardUsed"
            console.log("Karte bereits verwendet")
        }
    }

    property bool active: (StackView.status == StackView.Active) && parentStackActive
    onActiveChanged: cardIdField.forceActiveFocus()




    Row
    {
        id: layout
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20

        Item
        {
            width:  30
            height: 30
            anchors.verticalCenter:  parent.verticalCenter
            Icon
            {
                id: cardIccon
                anchors.centerIn: parent
                iconSize: 30
                icon: Icons.card
                iconColor: Colors.white
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


        TextField
        {
            id: cardIdField
            anchors.verticalCenter:  parent.verticalCenter
            placeholderText: qsTr("Karten ID")
            fontSize: Fonts.actionFontSize
            field.onTextEdited: docroot.state =""
            onAccepted:
            {
                if(cardIdField.text.length >= 8)
                    labService.call("getUserForCard", {"cardID": csvReader.turnCardID(cardIdField.text)}, docroot.callback)
            }
        }

    }

    TextLabel
    {
        id: errorLabel
        anchors.top: layout.bottom
        text: ""
        opacity:0
        anchors.horizontalCenter: layout.horizontalCenter
        anchors.horizontalCenterOffset: 0
        anchors.margins: 5
        fontSize:Fonts.smallControlFontSize

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


    StandardButton
    {
        id: confirmButton
        transparent: true
        icon: Icons.check
        iconColor: Colors.highlightBlue
        opacity: cardIdField.text.length >= 8
        visible: opacity > 0
        text: "Übernehmen"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        onClicked:
        {
            labService.call("getUserForCard", {"cardID": csvReader.turnCardID(cardIdField.text)}, docroot.callback )

            //docroot.confirm(reader.lastCardID)
        }

        Behavior on opacity
        {
            NumberAnimation{ }
        }
    }


   Timer
   {
      id:confirmTimer
      interval:  1000
      onTriggered: docroot.confirm(csvReader.turnCardID(cardIdField.text))
   }

    states:
    [
        State
        {
            name: "cardOK"

            PropertyChanges
            {

                target:  bubble
                opacity: 1
            }

            StateChangeScript
            {
                 script:
                 {
                     cardIdField.field.enabled = false
                     confirmTimer.start()
                 }
             }


            PropertyChanges
            {
                target: confirmButton
                opacity:0
            }
        },
        State
        {
            name: "cardUsed"

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
            StateChangeScript
            {
                 script:
                 {
                     cardIdField.text =""
                     cardIdField.forceActiveFocus()
                 }
             }


            PropertyChanges
            {
                target:  errorLabel
                text: qsTr("Karte bereits registriert!")
                opacity: 1

            }


            PropertyChanges
            {
                target: confirmButton
                opacity:0
            }
        }

    ]

    transitions:
    [
        Transition
        {
            from: ""
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

            NumberAnimation
            {
                property: "opacity"
            }
        }
    ]
}
