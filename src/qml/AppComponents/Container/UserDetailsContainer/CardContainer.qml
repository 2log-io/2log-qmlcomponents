

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
import CloudAccess 1.0
import QtQuick.Controls 2.3
import UIControls 1.0
import "../../Widgets"
import "../../Widgets/ScanCardWizzard"

Container {
    id: container
    headline: qsTr("Zugangskarten")
    property string userID

    width: parent.width

    header: Row {
        height: parent.height
        anchors.right: parent.right
        ContainerButton {

            anchors.verticalCenter: parent.verticalCenter
            visible: stackView.depth == 1
            icon: Icons.plus
            text: qsTr("Karte hinzufügen")
            onClicked: {
                stackView.push(scanCardWizzard)
            }
        }

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

    Stack {
        id: stackView
        initialItem: cardView
        width: parent.width
        height: cardModel.count == 0 ? 150 : currentItem.height

        CardReader {
            id: cardReader
        }

        SynchronizedListModel {
            id: cardModel
            resource: "labcontrol/users/cards/" + container.userID
        }

        Component {
            id: scanCardWizzard
            ScanCardWizzard {
                reader: cardReader
                onConfirm: {
                    var obj = {
                        "cardID": cardID,
                        "active": true
                    }
                    cardModel.append(obj)
                    stackView.pop(StackView.PushTransition)
                }
                onCancel: stackView.pop()
            }
        }

        Component {
            id: cardView
            Item {
                width: parent.width + 10
                height: cardGrid.count === 0 ? 150 : cardGrid.height
                TextLabel {
                    visible: cardGrid.count === 0
                    text: qsTr("Keine Karten zugewiesen")
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    wrapMode: Text.Wrap
                    fontSize: Fonts.bigDisplayFontSize
                    horizontalAlignment: Text.AlignHCenter
                    opacity: .2
                }

                DynamicGridView {
                    id: cardGrid
                    width: parent.width
                    interactive: false
                    cellHeight: 150
                    maxCellWidth: 160
                    model: cardModel

                    delegate: CardDelegate {
                        width: cardGrid.cellWidth
                        height: cardGrid.cellHeight
                        onCardClicked: cardModel.setProperty(index, "active",
                                                             !cardEnabled)
                        onRemoveClicked: cardModel.remove(index)
                        cardEnabled: active
                    }
                }
            }
        }

        Rectangle {
            z: 10
            color: Colors.darkBlue
            anchors.fill: parent
            opacity: !cardModel.initialized ? 1 : 0
            LoadingIndicator {
                visible: parent.opacity != 0
            }
        }
    }
}
