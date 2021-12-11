import QtQuick 2.5
import QtQuick.Layouts 1.3
import UIControls 1.0

Item {
    id: docroot
    height: 150
    width: 150

    property string icon: Icons.shield
    signal clicked
    property int permissionState: 0
    property date expires
    property string deviceName
    signal secondaryActionClicked
    property bool isTouch

    Rectangle {
        anchors.fill: parent
        color: Colors.white
        opacity: .03
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Icon {
            id: icon
            Layout.alignment: Qt.AlignCenter
            icon: docroot.icon
            iconSize: 40
            iconColor: Colors.white
            opacity: .5

            InfoBubble {
                id: bubble
                visible: false
                anchors.top: parent.bottom
                anchors.left: parent.right
                anchors.topMargin: -15
                anchors.leftMargin: 0
            }
        }

        Item {
            height: 40
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom

            Column {
                width: parent.width
                anchors.bottom: parent.bottom
                TextLabel {
                    text: docroot.deviceName
                    fontSize: Fonts.controlFontSize
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                TextLabel {
                    opacity: 0
                    id: expiresLabel
                    text: qsTr("bis %1").arg(Qt.formatDate(docroot.expires,
                                                           "dd.MM.yy"))
                    fontSize: Fonts.smallControlFontSize
                    color: Colors.grey
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: docroot.clicked()
    }

    Item {
        id: secondaryActionRect
        width: 30
        height: 30
        anchors.top: parent.top
        anchors.right: parent.right
        visible: mouse.containsMouse || docroot.isTouch
        opacity: 0
        Rectangle {
            anchors.fill: parent
            anchors.right: parent.right
            opacity: .1
        }

        Icon {
            id: secondaryActionIcon
            anchors.centerIn: parent
            icon: Icons.plus
            iconColor: Colors.highlightBlue
            iconSize: Fonts.smallControlFontSize
        }

        MouseArea {
            id: secondActionArea
            enabled: false
            anchors.fill: parent
            onClicked: docroot.secondaryActionClicked()
        }
    }

    states: [
        State {
            name: "active"
            when: docroot.permissionState === 1
            PropertyChanges {
                target: icon
                opacity: 1
            }

            PropertyChanges {
                target: bubble
                visible: true
            }

            PropertyChanges {
                target: expiresLabel
                opacity: 1
            }

            PropertyChanges {
                target: secondaryActionIcon
                iconColor: Colors.warnRed
                icon: Icons.minus
            }

            PropertyChanges {
                target: secondaryActionRect
                opacity: 1
            }

            PropertyChanges {
                target: secondActionArea
                enabled: true
            }
        },
        State {
            name: "forbidden"
            when: docroot.permissionState === 2
            PropertyChanges {
                target: icon
                opacity: 1
            }

            PropertyChanges {
                target: expiresLabel
                opacity: 1
            }

            PropertyChanges {
                target: bubble
                visible: true
                icon: Icons.forbidden
                infoColor: Colors.warnRed
            }

            PropertyChanges {
                target: secondaryActionIcon
                iconColor: Colors.warnRed
                icon: Icons.minus
            }

            PropertyChanges {
                target: secondaryActionRect
                opacity: 1
            }

            PropertyChanges {
                target: secondActionArea
                enabled: true
            }
        },
        State {}
    ]
}
