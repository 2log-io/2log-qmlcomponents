

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
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.3
import UIControls 1.0
import CloudAccess 1.0
import "../../Widgets"

Container {
    id: docroot
    headline: qsTr("Kontostand")

    property int referenceHeight
    property SynchronizedObjectModel userModel

    StackView {
        id: stack
        height: docroot.referenceHeight
        width: parent.width
        initialItem: initialItem
        clip: true

        Component {
            id: initialItem
            Item {

                Column {
                    anchors.centerIn: parent
                    spacing: 30
                    Row {
                        spacing: 10
                        anchors.horizontalCenter: parent.horizontalCenter

                        TextLabel {
                            Binding on text {
                                value: (userModel.balance / 100).toLocaleString(
                                           Qt.locale("de_DE"))
                            }
                            fontSize: Fonts.bigDisplayFontSize
                        }

                        TextLabel {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 5
                            text: "EUR"
                            color: Colors.grey
                            opacity: .4
                            fontSize: Fonts.bigDisplayUnitFontSize
                        }
                    }

                    StandardButton {
                        text: qsTr("Geld aufladen oder abheben")
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: stack.push(setMoney)
                    }
                }
            }
        }

        Component {
            id: setMoney
            Item {
                id: setMoneyPage
                property bool active: (StackView.status === StackView.Active)
                onActiveChanged: if (active)
                                     priceLabel.field.forceActiveFocus()
                ServiceModel {
                    id: labService
                    service: "lab"
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 30

                    Row {
                        spacing: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        TextField {
                            id: priceLabel
                            clip: false
                            width: 100
                            placeholderText: "0,00"
                            field.validator: RegExpValidator {
                                regExp: /^[-]?\d+([\.,]\d{2})?$/
                            }
                            field.horizontalAlignment: Text.AlignRight
                            fontSize: Fonts.bigDisplayFontSize
                            lineOnHover: true
                        }

                        TextLabel {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "EUR"
                            color: Colors.grey
                            opacity: .4
                            fontSize: Fonts.bigDisplayUnitFontSize
                        }
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 40
                        spacing: 10

                        StandardButton {
                            text: "Aufladen"
                            width: 110
                            icon: Icons.plus
                            onClicked: {
                                var intval = Math.abs(
                                            HelperFunctions.priceTextToInt(
                                                priceLabel.text))
                                var data = {
                                    "userID": userModel.uuid,
                                    "value": intval
                                }
                                labService.call("transferMoney", data,
                                                function () {
                                                    stack.replace(
                                                                initialItem,
                                                                StackView.PushAnimation)
                                                })
                            }
                        }
                        StandardButton {
                            text: "Abbuchen"
                            width: 110
                            icon: Icons.minus
                            onClicked: {
                                var intval = Math.abs(
                                            HelperFunctions.priceTextToInt(
                                                priceLabel.text)) * -1
                                var data = {
                                    "userID": userModel.uuid,
                                    "value": intval
                                }
                                labService.call("transferMoney", data,
                                                function () {
                                                    stack.replace(
                                                                initialItem,
                                                                StackView.PushAnimation)
                                                })
                            }
                        }
                    }
                }

                StandardButton {
                    transparent: true
                    icon: Icons.leftAngle
                    text: qsTr("Abbrechen")
                    anchors.bottom: parent.bottom
                    onClicked: stack.pop()
                    opacity: setMoneyPage.active ? 1 : 0

                    Behavior on opacity {
                        NumberAnimation {}
                    }
                }
            }
        }

        Rectangle {
            z: 10
            color: Colors.darkBlue
            anchors.fill: parent
            opacity: !userModel.initialized ? 1 : 0
            LoadingIndicator {
                visible: parent.opacity != 0
            }
        }
    }
}
