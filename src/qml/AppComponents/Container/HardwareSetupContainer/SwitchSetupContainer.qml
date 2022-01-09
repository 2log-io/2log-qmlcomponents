

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
import QtQuick.Controls 2.0
import UIControls 1.0
import CloudAccess 1.0
import AppComponents 1.0
import "../../Dialogs/DeviceProvisioningDialog"

Container {
    id: docroot

    property string deviceID
    property string shortID
    property bool waitingForDevice

    function callback(data) {
        if (data.errCode >= 0) {
            stack.replace(dotOverview, StackView.PushTransition)
        } else {
            var errorMsg = qsTr("Unbekannter Fehler")
            switch (data.errCode) {
            case -4:
                stack.push(alreadyInUse)
                return
            case -10:
                errorMsg = qsTr("Unbekannte Controller-ID")
                break
            case -11:
                errorMsg = qsTr("Kein Gerät gefunden")
                break
            case -12:
                errorMsg = qsTr("Falscher Gerätetyp")
                break
            }

            stack.currentItem.showError(errorMsg)
        }
    }

    function provisioningCallback(data) {
        if (data.errCode < 0) {
            stack.replace(dotOverview, StackView.PushTransition)
            var errorMsg = qsTr("Unbekannter Fehler")
            switch (data.errCode) {
            case -4:
                stack.push(alreadyInUse)
                return
            case -10:
                errorMsg = qsTr("Unbekannte Controller-ID")
                break
            case -11:
                errorMsg = qsTr("Kein Gerät gefunden")
                break
            case -12:
                errorMsg = qsTr("Falscher Gerätetyp")
                break
            }

            stack.currentItem.showError(errorMsg)
        } else {
            stack.push(waitingForDevice)
            docroot.waitingForDevice = true
        }
    }

    headline: qsTr("Switch")
    property DeviceModel deviceModel

    states: [
        State {
            name: "na"
            when: !deviceModel.available

            PropertyChanges {
                target: infoBubble
                icon: Icons.question
                infoColor: Colors.white
            }
        },

        State {
            name: "off"
            when: !deviceModel.deviceOnline

            PropertyChanges {
                target: infoBubble
                icon: Icons.offline
                infoColor: Colors.warnRed
            }
        }
    ]

    header: Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: docroot.spacing
        ContainerButton {
            id: disconnectBtn

            anchors.verticalCenter: parent.verticalCenter
            icon: Icons.disconnect
            enabled: stack.currentItem.stackID === "info"
                     && deviceModel.available && deviceModel.deviceOnline
            text: qsTr("Trennen")

            ServiceModel {
                id: machineControlService
                service: "devices"
            }

            onClicked: {
                machineControlService.call("unhookWithMapping", {
                                               "mapping": deviceModel.resource
                                           }, function (data) {})
            }
        }

        ContainerButton {
            id: setupbtn
            anchors.verticalCenter: parent.verticalCenter
            icon: Icons.swap
            enabled: stack.currentItem.stackID === "info"
                     && deviceModel.available
            text: qsTr("Tauschen")

            onClicked: {
                stack.push(isAlreadyHooked)
            }
        }
    }

    RowLayout {
        width: parent.width
        spacing: docroot.spacing

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width / 3
            height: 150

            Image {
                width: parent.width
                height: parent.height
                source: "qrc:/switch_line_svg"
                fillMode: Image.PreserveAspectFit

                Item {
                    width: parent.paintedWidth
                    height: parent.paintedHeight
                    anchors.centerIn: parent
                    InfoBubble {
                        id: infoBubble
                        size: 32
                        x: parent.width * 0.6
                        y: parent.height * 0.75
                        iconSize: 16
                    }
                }
            }
        }

        StackView {
            id: stack
            initialItem: dotOverview
            Layout.fillWidth: true
            Layout.fillHeight: true
            height: 150
            clip: true

            Component {
                id: setup
                ChangeDevicePage {
                    property string stackID: "setup"
                    onBack: stack.pop()
                    onConfirm: {
                        docroot.shortID = shortID
                        var data = {
                            "deviceID": docroot.deviceID,
                            "shortID": shortID,
                            "force": false
                        }
                        machineControlService.call("hookSwitch", data,
                                                   docroot.callback)
                    }

                    ServiceModel {
                        id: machineControlService
                        service: "machineControl"
                    }
                }
            }

            Component {
                id: isAlreadyHooked
                IsAlreadyHookedPage {
                    onBack: stack.pop()
                    property string stackID: "isAlreadyHooked"
                    onYes: stack.push(setup)
                    onNo: {

                        provisioningPopup.open()
                    }
                }
            }

            Component {
                id: waitingForDevice
                WaitingForDevicePage {
                    onTimeOut: stack.replace(waitingForDeviceTimeout,
                                             StackView.PushTransition)
                    property string stackID: "waitingForDevice"
                }
            }

            Component {
                id: waitingForDeviceTimeout
                TryAgainPage {
                    onBack: stack.pop()
                    onTryAgain: provisioningPopup.open()
                }
            }

            DeviceProvisioningPopup {
                id: provisioningPopup
                targetSSID: "I'm a Switch"
                ServiceModel {
                    id: deviceService
                    service: "machineControl"
                }

                onProvisioningFinished: {
                    deviceService.call("prepareSwitchMappingWighUUID", {
                                           "deviceID": docroot.deviceID,
                                           "uuid": uuid
                                       }, docroot.provisioningCallback)
                }

                Connections {
                    target: deviceModel
                    function onDeviceOnlineChanged() {
                        if (deviceModel.deviceOnline
                                && docroot.waitingForDevice) {
                            stack.replace(dotOverview, StackView.PushTransition)
                            docroot.waitingForDevice = false
                        }
                    }
                }
            }
            Component {
                id: alreadyInUse
                AlreadeInUsePage {
                    onBack: stack.pop()
                    property string stackID: "alreadyInUse"
                    onConfirm: machineControlService.call("hookSwitch", {
                                                              "deviceID": docroot.deviceID,
                                                              "shortID": docroot.shortID,
                                                              "force": true
                                                          }, docroot.callback)
                    ServiceModel {
                        id: machineControlService
                        service: "machineControl"
                    }
                }
            }

            Component {
                id: dotOverview

                StackLayout {
                    property string stackID: "info"
                    currentIndex: deviceModel.available ? 0 : 1
                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column {
                            anchors.centerIn: parent
                            spacing: 10

                            //                            Row
                            //                            {
                            //                                spacing: 20
                            //                                TextLabel
                            //                                {
                            //                                    text: deviceModel.shortID
                            //                                    Layout.fillWidth: true
                            //                                    font.styleName: "Medium"
                            //                                    font.family: Fonts.simplonMono
                            //                                    fontSize: Fonts.bigDisplayFontSize
                            //                                }
                            //                            }
                            DeviceInfoPage {
                                deviceModel: docroot.deviceModel
                            }
                            Row {
                                spacing: 20
                                ToggleSwitch {
                                    enabled: deviceModel.deviceOnline
                                    checked: docroot.deviceModel
                                             && docroot.deviceModel.getProperty(
                                                 "on").value
                                             !== undefined ? docroot.deviceModel.getProperty(
                                                                 "on").value : false
                                    checkable: false
                                    onClicked: docroot.deviceModel.getProperty(
                                                   "on").value = !docroot.deviceModel.getProperty(
                                                   "on").value
                                }
                                TextLabel {
                                    text: docroot.deviceModel.getProperty(
                                              "on").value ? "Ein" : "Aus"
                                    fontSize: Fonts.controlFontSize
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column {
                            anchors.right: parent.right
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.margins: 30
                            width: parent.width
                            spacing: 20

                            TextLabel {
                                width: parent.width
                                text: qsTr(
                                          "Aktuell ist kein Switch zugewiesen.")
                                wrapMode: Text.Wrap

                                Layout.fillWidth: true
                                font.styleName: "Medium"
                                fontSize: Fonts.subHeaderFontSize
                            }
                        }

                        StandardButton {
                            text: qsTr("Jetzt einrichten")
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            transparent: true
                            icon: Icons.rightAngle
                            iconAlignment: Qt.AlignRight

                            onClicked: {
                                stack.push(isAlreadyHooked)
                            }
                        }
                    }
                }
            }
        }
    }
}
