

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
import QtQuick.Controls 2.3
import UIControls 1.0
import "../../Widgets"

Item {
    id: delegate

    Behavior on y {
        NumberAnimation {}
    }

    property bool cardEnabled
    signal cardClicked
    signal removeClicked

    BaseItem {
        id: frame
        anchors.bottomMargin: 10
        anchors.rightMargin: 10
        anchors.fill: parent
        borderOpacity: .6

        Item {
            height: 40
            width: parent.width
            anchors.top: parent.top
            anchors.margins: 10
            TextLabel {
                anchors.horizontalCenter: parent.horizontalCenter
                text: cardID
                fontSize: Fonts.controlFontSize
            }
        }

        Item {
            id: iconFrame
            width: icon.width
            height: icon.height
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -10

            Icon {
                id: icon

                icon: Icons.card
                iconSize: 40
                iconColor: Colors.white
                opacity: .5
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
        }

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                delegate.cardClicked()
            }
        }

        Row {
            id: buttonRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: -1
            anchors.bottom: parent.bottom
            anchors.margins: 10

            RadioGroupButton {
                id: radioLevel0
                alignment: Qt.AlignLeft
                iconChar: Icons.forbidden
                iconCheckedColor: Colors.warnRed
                onClicked: if (!checked)
                               delegate.cardClicked()
                toolTipText: checked ? qsTr("Karte deaktiviert") : qsTr(
                                           "Karte deaktivieren")
            }

            RadioGroupButton {
                id: radioLevel1
                alignment: Qt.AlignRight
                autoExclusive: true
                iconChar: Icons.check
                iconCheckedColor: Colors.highlightBlue
                onClicked: if (!checked)
                               delegate.cardClicked()
                toolTipText: !checked ? qsTr("Karte aktivieren") : qsTr(
                                            "Karte aktiv")
            }

            Item {
                width: 10
                height: 1
            }

            RadioGroupButton {
                id: deleteBtn
                alignment: -1
                iconChar: Icons.trash
                iconCheckedColor: Colors.warnRed
                onClicked: delegate.removeClicked()
                toolTipText: qsTr("Karte löschen")
            }
        }
    }

    states: [
        State {
            name: "active"
            when: delegate.cardEnabled

            PropertyChanges {
                target: frame
                borderColor: Colors.highlightBlue
            }

            PropertyChanges {
                target: radioLevel1
                checked: true
            }
        },

        State {
            name: "inactive"
            when: !delegate.cardEnabled

            PropertyChanges {
                target: balken
                width: balken.parent.width
            }

            PropertyChanges {
                target: frame
                borderColor: Colors.warnRed
                backgroundOpacity: 0
            }

            PropertyChanges {
                target: radioLevel0
                checked: true
            }

            PropertyChanges {
                target: icon
                opacity: .25
            }
        }
    ]

    transitions: [
        Transition {

            PropertyAction {
                property: "visible"
            }

            PropertyAnimation {
                properties: "color,opacity, borderColor, width"
                easing.type: Easing.OutQuad
            }
        }
    ]
}
