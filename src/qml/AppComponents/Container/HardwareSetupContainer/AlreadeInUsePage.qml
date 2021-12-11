

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
    signal confirm
    signal back

    width: parent ? parent.width : 0

    function showError(errorMsg) {
        shortIDField.showError(errorMsg)
    }

    TextLabel {
        anchors.fill: parent
        anchors.leftMargin: 12
        wrapMode: Text.WordWrap
        anchors.bottomMargin: 20
        verticalAlignment: Text.AlignVCenter
        text: qsTr("Dieses Gerät ist bereits einer anderen Ressource zugewiesen. Möchtest du es stattdessen dieser Ressource hier zuweisen?")
    }
    StandardButton {
        transparent: true
        icon: Icons.leftAngle
        text: qsTr("Zurück")
        anchors.bottom: parent.bottom
        onClicked: docroot.back()
        opacity: docroot.active ? 1 : 0

        Behavior on opacity {
            NumberAnimation {}
        }
    }

    StandardButton {
        id: confirmButton
        transparent: true
        icon: Icons.link
        visible: opacity > 0
        text: qsTr("Ja")
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        onClicked: {
            docroot.confirm()
        }

        Behavior on opacity {
            NumberAnimation {}
        }
    }
}
