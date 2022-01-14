

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
import QtQuick
import QtQuick.Controls 2.3
import UIControls 1.0
import QtQuick.Layouts 1.3
import CloudAccess 1.0
import AppComponents 1.0

import "../../Widgets"
import "../../Widgets/ScanCardWizzard"

Container {
    id: docroot
    Layout.fillHeight: true
    Layout.fillWidth: true
    headline: "Konto"

    property string money
    property string cardID
    property int cents: parseInt(money.replace(",", ".") * 100)

    header: Row {
        height: parent.height
        anchors.right: parent.right

        Loader {
            visible: active
            active: stackView.depth === 2
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: Row {
                spacing: -1
                anchors.verticalCenter: parent.verticalCenter
                RadioGroupButton {
                    id: radioLevel2
                    toolTipText: qsTr("Manuelle Eingabe")
                    alignment: Qt.AlignLeft
                    iconChar: Icons.keyboard
                    iconCheckedColor: Colors.white
                    autoExclusive: true
                    borderColor: Qt.lighter(Colors.greyBlue, 1.25)
                    checked: stackView.currentItem.manual ? stackView.currentItem.manual : false
                    onClicked: stackView.currentItem.manual = true
                    checkedBackgroundColor: Colors.black_op25
                }

                RadioGroupButton {
                    id: radioLevel0
                    toolTipText: qsTr("Mit Dot scannen")
                    iconCheckedColor: Colors.white
                    alignment: Qt.AlignRight
                    autoExclusive: true
                    borderColor: Qt.lighter(Colors.greyBlue, 1.25)
                    iconChar: Icons.dot
                    checked: !stackView.currentItem.manual
                    onClicked: stackView.currentItem.manual = false
                    checkedBackgroundColor: Colors.black_op25
                }
            }
        }
    }

    StackView {
        clip: true
        initialItem: initialItem
        height: 162
        width: parent.width
        id: stackView

        CardReader {
            id: cardReader
        }

        Component {
            id: wizzard
            ScanCardWizzard {
                reader: cardReader
                onCancel: stackView.pop()
                onConfirm: {
                    docroot.cardID = cardID
                    stackView.pop(StackView.PushTransition)
                }
            }
        }

        Component {
            id: initialItem
            Item {

                Column {
                    anchors.centerIn: parent
                    spacing: 30
                    Row {
                        spacing: docroot.spacing
                        anchors.horizontalCenter: parent.horizontalCenter

                        Icon {
                            icon: Icons.coins
                            anchors.verticalCenter: parent.verticalCenter
                            iconSize: 30
                            iconColor: Colors.white
                            opacity: .5
                        }

                        TextField {
                            id: priceLabel
                            lineOnHover: true
                            clip: false
                            width: 100
                            placeholderText: "0,00"
                            field.validator: RegularExpressionValidator {
                                regularExpression: /^[-]?\d+([\.,]\d{2})?$/
                            }
                            field.horizontalAlignment: Text.AlignRight
                            fontSize: Fonts.bigDisplayFontSize
                            onTextChanged: docroot.money = text
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
                        spacing: docroot.spacing
                        width: parent.width

                        Icon {
                            opacity: docroot.cardID !== "" ? 1 : .5
                            icon: Icons.card
                            anchors.verticalCenter: parent.verticalCenter
                            iconSize: 30
                            iconColor: Colors.white
                        }

                        TextLabel {
                            text: docroot.cardID
                            visible: text !== ""
                            anchors.verticalCenter: parent.verticalCenter
                            opacity: .5
                            fontSize: Fonts.bigDisplayUnitFontSize
                        }

                        StandardButton {
                            visible: cardID === ""
                            text: qsTr("Karte hinzufügen")
                            width: 154
                            onClicked: stackView.push(wizzard)
                        }
                    }
                }
            }
        }
    }

    function clear() {
        priceLabel.text = ""
        cardIDField.text = ""
    }
}
