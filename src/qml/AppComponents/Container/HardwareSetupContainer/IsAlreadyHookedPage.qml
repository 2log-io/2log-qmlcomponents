

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
import UIControls 1.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import CloudAccess 1.0
import AppComponents 1.0

Item {
    id: docroot

    property bool active: (StackView.status == StackView.Active)

    signal yes
    signal no
    signal back

    width: parent ? parent.width : 0

    function showError(errorMsg) {
        shortIDField.showError(errorMsg)
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -20
        anchors.left: parent.left
        width: parent.width
        anchors.leftMargin: 12
        spacing: 20

        TextLabel {
            width: parent.width
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Ist das Device bereits mit Ihrer 2log Instanz verbunden?")
        }

        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            visible: docroot.width <= 260
            StandardButton {
                icon: Icons.no
                visible: opacity > 0
                text: qsTr("Nein")
                onClicked: {
                    docroot.no()
                }

                Behavior on opacity {
                    NumberAnimation {}
                }
            }

            StandardButton {
                //   transparent: true
                icon: Icons.yes
                visible: opacity > 0
                text: qsTr("Ja")

                onClicked: {
                    docroot.yes()
                }

                Behavior on opacity {
                    NumberAnimation {}
                }
            }
        }
    }

    Row {
        spacing: 10
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        visible: docroot.width > 260
        StandardButton {
            icon: Icons.no
            visible: opacity > 0
            text: qsTr("Nein")
            onClicked: {
                docroot.no()
            }

            Behavior on opacity {
                NumberAnimation {}
            }
        }

        StandardButton {
            icon: Icons.yes
            visible: opacity > 0
            text: qsTr("Ja")

            onClicked: {
                docroot.yes()
            }

            Behavior on opacity {
                NumberAnimation {}
            }
        }
    }

    StandardButton {
        transparent: true
        icon: Icons.leftAngle
        text: qsTr("Abbrechen")
        anchors.bottom: parent.bottom
        onClicked: docroot.back()
        opacity: docroot.active ? 1 : 0

        Behavior on opacity {
            NumberAnimation {}
        }
    }
}
