

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
import CloudAccess 1.0
import AppComponents 1.0
import DeviceProvisioning 1.0

Item {
    id: docroot
    property bool active

    signal cancel

    onActiveChanged: if (active) {

                     }

    Column {
        anchors.centerIn: parent
        width: parent.width - 80
        spacing: 50

        LogoSpinner {
            size: 250
            backgroundColor: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TextLabel {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            text: {
                switch (ProvisioningManager.state) {
                case ProvisioningManager.PROVISIONING_CONNECTING_WIFI:
                    return qsTr("Verbinde mit Gerätenetzwerk...")
                case ProvisioningManager.PROVISIONING_CONNECTED_WIFI:
                    return qsTr("W-LAN verbunden.")
                case ProvisioningManager.PROVISIONING_CONNECTING_SOCKET:
                    return qsTr("Warte auf Datenverbindung...")
                case ProvisioningManager.PROVISIONING_TRANSFERING:
                    return qsTr("Übertrage Daten...")
                case ProvisioningManager.PROVISIONING_TRANSFERING_SUCCEEDED:
                    return qsTr("Daten erfolgreich gesendet.")
                case ProvisioningManager.PROVISIONING_ERROR:
                {
                    switch (ProvisioningManager.errorCode) {
                    case ProvisioningManager.ERR_PROVISIONING_DEVICE_NOT_FOUND:
                        return qsTr("Gerät nicht gefunden. Kontrolliere noch mal ob sich das Gerät wirklich im Pairing Modus befindet.")
                    case ProvisioningManager.ERR_PROVISIONING_WIFI_TEST_FAILED:
                        return qsTr("Falsches W-LAN Passwort. Versuchs noch einmal.")
                    case ProvisioningManager.ERR_PROVISIONING_DEVICE_NOT_FOUND:
                        return qsTr("Die Verbindung antwortet nicht. Versuchs noch einmal.")
                    case ProvisioningManager.ERR_PROVISIONING_TIMEOUT:
                        return qsTr("Gerät antwortet nicht. Versuchs noch einmal.")
                    }
                }
                case ProvisioningManager.PROVISIONING_SUCCESS:
                    return qsTr("Konfiguration abgeschlossen.")
                case ProvisioningManager.PROVISIONING_CONNECTING_TO_HOME_WIFI:
                    return qsTr("Ursprüngliche Verbindung wiederherstellen...")
                case ProvisioningManager.PROVISIONING_CONNECTED_TO_HOME_WIFI:
                    return qsTr("Verbinde mit 2log Server...")
                case ProvisioningManager.PROVISIONING_ABORTING:
                    return qsTr("Abbrechen...")
                }
            }
        }
    }

    StandardButton {
        transparent: true
        icon: Icons.leftAngle
        text: qsTr("Abbrechen")
        anchors.bottom: parent.bottom
        opacity: parent.active ? 1 : 0
        onClicked: {
            docroot.cancel()
        }

        Behavior on opacity {
            NumberAnimation {}
        }
    }
}
