

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
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.4
import UIControls 1.0
import AppComponents 1.0
import DeviceProvisioning 1.0

Item {
    id: docroot
    property bool active: (StackView.status == StackView.Active)
    visible: StackView.status !== StackView.Inactive
    signal next(string ssid, string password)
    signal cancel

    Column {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: parent.width - 80
        spacing: 50

        Icon {
            icon: Icons.wifi
            iconSize: 100
            anchors.horizontalCenter: parent.horizontalCenter
            iconColor: Colors.grey
        }

        TextField {
            id: ssidField
            width: parent.width
            placeholderText: qsTr("SSID")
            fontSize: Fonts.headerFontSze
            hideLine: true
            lineOnHover: true
            text: ProvisioningManager.currentSSID
            //wrapMode: Text.Wrap
            field.horizontalAlignment: Qt.AlignHCenter
            font.family: Fonts.simplonMono
        }

        TextField {
            id: pass
            placeholderText: qsTr("W-LAN Passwort")
            icon: Icons.lock
            field.echoMode: TextInput.Password
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    StandardButton {
        transparent: true
        icon: Icons.cancel
        anchors.bottom: parent.bottom
        text: qsTr("Abbrechen")
        onClicked: docroot.cancel()
        opacity: parent.active ? 1 : 0

        Behavior on opacity {
            NumberAnimation {}
        }
    }

    StandardButton {
        transparent: true
        icon: Icons.rightAngle
        text: qsTr("Weiter")
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        onClicked: docroot.next(ssidField.text, pass.text)
        opacity: parent.active ? 1 : 0
        iconAlignment: Qt.AlignRight

        Behavior on opacity {
            NumberAnimation {}
        }
    }
}
