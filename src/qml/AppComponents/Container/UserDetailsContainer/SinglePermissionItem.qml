

/*   2log.io
 *   Copyright (C) 2021 - 2log.io | mail@2log.io,  mail@friedemann-metzger.de
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.5
import QtQuick.Layouts 1.3
import AppComponents 1.0
import UIControls 1.0

BaseItem {
    id: docroot
    height: 154
    width: 150

    property string icon: Icons.group
    property bool hasGroupPermission
    signal clicked
    signal dateSelected(date date)
    property int permissionState: 0
    property date expires
    property string deviceName
    signal secondaryActionClicked
    property bool isTouch
    property string iconImage
    signal setLevel(int level)
    borderOpacity: .6

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: docroot.clicked()
    }

    Row {
        id: buttonRow
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: -1
        anchors.bottom: parent.bottom
        anchors.margins: 10

        RadioGroupButton {
            id: radioLevel2
            alignment: Qt.AlignLeft
            iconChar: Icons.forbidden
            iconCheckedColor: Colors.warnRed
            onClicked: docroot.setLevel(2)
            toolTipText: permissionState == 2 ? qsTr("Zugriff immer verboten") : qsTr(
                                                    "Zugriff immer verbieten")
        }

        RadioGroupButton {
            id: radioLevel0
            alignment: Qt.AlignCenter
            autoExclusive: true
            iconChar: docroot.hasGroupPermission ? Icons.group : Icons.minus
            iconCheckedColor: docroot.hasGroupPermission ? Colors.highlightBlue : Colors.white
            onClicked: docroot.setLevel(0)
            toolTipText: permissionState
                         == 0 ? qsTr("Von Gruppenberechtigung abhängig") : qsTr(
                                    "Von Gruppenberechtigung abhängig machen")
        }

        RadioGroupButton {
            id: radioLevel1
            alignment: Qt.AlignRight
            autoExclusive: true
            iconChar: Icons.check
            iconCheckedColor: Colors.highlightBlue
            onClicked: docroot.setLevel(1)
            toolTipText: permissionState == 1 ? qsTr("Zugriff erlaubt") : qsTr(
                                                    "Zugriff erlauben")
        }
    }

    Item {
        width: 40
        height: 40
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        id: iconFrame

        Icon {
            id: icon
            opacity: docroot.iconImage == "" ? .5 : 0
            anchors.centerIn: parent
            icon: Icons.plug
            iconSize: 40
            iconColor: Colors.white
        }

        Image {
            id: image
            anchors.centerIn: parent
            sourceSize.width: 40
            sourceSize.height: 40
            width: 40
            height: 40
            source: docroot.iconImage == "" ? "" : "qrc:/" + docroot.iconImage
        }
    }
    Item {
        height: 2
        width: iconFrame.width
        anchors.centerIn: iconFrame
        rotation: -45

        Rectangle {
            id: balken
            color: Colors.warnRed
            width: 0
            height: parent.height
            Shadow {
                opacity: .1
            }
        }
    }

    Item {
        height: 40
        width: parent.width
        anchors.top: parent.top
        anchors.margins: 10

        TextLabel {
            text: docroot.deviceName
            fontSize: Fonts.controlFontSize
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }
    }

    TextLabel {
        id: expiresLabel

        property string dateString: Qt.formatDate(docroot.expires, "dd.MM.yy")
        anchors.bottom: buttonRow.top
        anchors.margins: 6
        opacity: dateString !== ""
        text: qsTr("bis %1").arg(dateString)
        fontSize: Fonts.smallControlFontSize
        color: Colors.grey
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: dateRect
            anchors.fill: parent
            anchors.margins: -2
            anchors.rightMargin: -4
            anchors.leftMargin: -4
            radius: 3
            opacity: dateMouseArea.containsMouse || dateFlyout.opened ? .1 : 0

            MouseArea {
                id: dateMouseArea
                anchors.fill: parent
                hoverEnabled: true
                enabled: expiresLabel.opacity === 1
                onClicked: dateFlyout.open()
            }

            FlyoutBox {
                id: dateFlyout
                parent: dateRect

                Loader {
                    active: dateFlyout.opened
                    width: 250
                    height: 250

                    /*
                    sourceComponent: CalendarWidget {
                        anchors.fill: parent
                        selectedDate: docroot.expires
                        onClicked: docroot.dateSelected(date)
                    }*/
                }
            }
        }
    }

    states: [
        State {
            name: "active"
            when: docroot.permissionState === 1

            PropertyChanges {
                target: radioLevel1
                checked: true
            }

            PropertyChanges {
                target: docroot
                borderColor: Colors.highlightBlue
                //     borderOpacity: 1
            }
        },
        State {
            name: "forbidden"
            when: docroot.permissionState === 2

            PropertyChanges {
                target: expiresLabel
                opacity: 1
            }

            PropertyChanges {
                target: radioLevel2
                checked: true
            }

            PropertyChanges {
                target: docroot
                borderColor: Colors.warnRed
                backgroundOpacity: 0
                //    borderOpacity: 1
            }

            PropertyChanges {
                target: balken
                width: balken.parent.width
            }

            PropertyChanges {
                target: iconFrame
                opacity: .5
            }
        },
        State {
            name: "noneButGroup"
            when: docroot.permissionState === 0 && docroot.hasGroupPermission

            PropertyChanges {
                target: expiresLabel
                opacity: 0
            }

            PropertyChanges {
                target: radioLevel0
                checked: true
            }

            PropertyChanges {
                target: docroot
                borderColor: Colors.highlightBlue
            }
        },
        State {
            name: "none"
            when: docroot.permissionState === 0 && !docroot.hasGroupPermission

            PropertyChanges {
                target: expiresLabel
                opacity: 0
            }

            PropertyChanges {
                target: radioLevel0
                checked: true
            }

            PropertyChanges {
                target: docroot
                borderColor: Colors.warnRed
                backgroundOpacity: 0
            }

            PropertyChanges {
                target: balken
                width: balken.parent.width
            }

            PropertyChanges {
                target: iconFrame
                opacity: .5
            }
        }
    ]

    transitions: [
        Transition {

            PropertyAction {
                property: "visible"
            }

            //            ColorAnimation
            //            {
            //                target:docroot
            //               property: "borderColor"
            //            }
            PropertyAnimation {
                properties: "color,opacity, borderColor, width"
                easing.type: Easing.OutQuad
            }
        }
    ]
}
