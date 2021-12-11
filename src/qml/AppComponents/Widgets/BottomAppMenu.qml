import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import UIControls 1.0
import AppComponents 1.0
import QtGraphicalEffects 1.12

Item {
    id: docroot
    height: 60
    width: parent.width
    signal clicked
    property StackView stackView
    property bool open: true

    states: [
        State {
            name: "closed"
            when: !docroot.open

            PropertyChanges {
                target: docroot
                opacity: 0
                height: 0
            }
        }
    ]

    transitions: [
        Transition {
            PropertyAnimation {
                properties: "height, opacity"
                target: docroot
            }
        }
    ]

    Item {
        width: parent.width
        height: 60
        anchors.top: parent.top
        Rectangle {
            anchors.fill: parent
            color: Colors.backgroundDarkBlue
        }

        Shadow {
            shadowBottom: true
            shadowRight: false
            shadowLeft: false
            opacity: .1
        }

        RowLayout {
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            height: parent.height

            BottomAppMeuButton {
                text: qsTr("Benutzer")
                icon: Icons.user

                selected: stackView.depth > 0 && stackView.currentItem
                          !== null ? stackView.currentItem.viewID === "users" : false
                onClicked: {
                    stackView.replace(null, users)
                    docroot.clicked()
                }
            }

            BottomAppMeuButton {
                text: qsTr("Ressourcen")
                icon: Icons.plug
                selected: stackView.depth > 0 && stackView.currentItem
                          !== null ? stackView.currentItem.viewID === "devices" : false
                onClicked: {
                    stackView.replace(null, devices)
                    docroot.clicked()
                }
            }

            BottomAppMeuButton {
                text: qsTr("Statistik")
                icon: Icons.statistics

                selected: stackView.depth > 0 && stackView.currentItem
                          !== null ? stackView.currentItem.viewID === "statistics" : false
                onClicked: {
                    stackView.replace(null, statistics)
                    docroot.clicked()
                }
            }
            BottomAppMeuButton {
                text: qsTr("Settings")
                icon: Icons.gear

                selected: stackView.depth > 0 && stackView.currentItem
                          !== null ? stackView.currentItem.viewID === "settings" : false
                onClicked: {
                    stackView.replace(null, settings)
                    docroot.clicked()
                }
            }
        }
    }
}
