

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
import QtQuick 2.14
import QtQml 2.14
import QtQuick.Controls 2.5
import UIControls 1.0
import CloudAccess 1.0
import QtQuick.Layouts 1.3
import "../../Widgets"

Container {
    id: docroot
    width: parent.width
    headline: qsTr("Berechtigungsgruppen")
    property color lineColor: Colors.lightGrey

    GridLayout {
        id: grid
        width: parent.width
        height: header.height + groupCheckList.contentHeight + 50
        columns: 2
        rows: 2
        rowSpacing: 0

        Item {
            id: dummy

            width: 150
            Layout.minimumWidth: 150
            height: headerWrapper.height
            Layout.column: 0
            Layout.row: 0

            SynchronizedListLookupModel {
                id: groupModel
                resource: "labcontrol/groups"
                lookupKey: "uuid"
            }
        }

        Item {
            id: headerWrapper
            Layout.fillWidth: true
            Layout.column: 1
            Layout.row: 0
            Layout.minimumHeight: header.height
            Layout.maximumHeight: header.height

            Flickable {
                id: flick
                clip: true
                interactive: true
                contentHeight: height
                anchors.fill: parent
                contentWidth: header.width

                Binding on contentX {
                    value: flick2.contentX
                    when: flick2.moving
                    restoreMode: Binding.RestoreBinding
                }

                HeaderTest {
                    id: header
                    lineColor: docroot.lineColor
                }
            }
        }

        Item {

            id: labelWrapper
            Layout.column: 0
            Layout.row: 1
            z: 10
            width: 150
            Layout.minimumWidth: 150
            Layout.maximumWidth: 150
            Layout.minimumHeight: labelList.contentHeight
            Layout.maximumHeight: labelList.contentHeight
            Layout.alignment: Qt.AlignTop

            ListView {
                clip: true
                id: labelList
                interactive: false
                contentY: groupCheckList.contentY
                width: parent.width
                height: parent.height
                model: groupModel.keys

                delegate: Item {
                    height: 50
                    width: parent.width

                    TextLabel {
                        fontSize: Fonts.controlFontSize
                        horizontalAlignment: Text.AlignRight
                        anchors.verticalCenter: parent.verticalCenter
                        text: groupModel.getItem(modelData).name
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                    }
                }
            }
        }

        Flickable {
            id: flick2
            Layout.fillWidth: true
            Layout.column: 1
            Layout.row: 1
            Layout.minimumHeight: height
            Layout.maximumHeight: height
            height: groupCheckList.height
            contentHeight: height
            contentWidth: flick.contentWidth
            Layout.alignment: Qt.AlignTop

            Binding on contentX {
                value: flick.contentX
                when: flick.moving
                restoreMode: Binding.RestoreBinding
            }

            clip: true
            ListView {
                id: groupCheckList
                clip: true
                height: contentHeight
                model: groupModel.keys
                interactive: false
                width: flick.contentWidth

                delegate: DelegateCheckBoxes {
                    groupLookupModel: groupModel
                    lineColor: docroot.lineColor
                    groupID: modelData
                    onDeleteGroup: deleteGroupDialog.openDialog(groupID)

                    Rectangle {
                        width: parent.width
                        color: docroot.lineColor
                        height: 1
                        opacity: .2
                        anchors.bottom: parent.bottom
                        visible: index !== groupCheckList.count - 1
                    }
                }
            }
        }

        Item {
            Layout.minimumWidth: 150
            Layout.maximumWidth: 150
            Layout.minimumHeight: 50
            Layout.maximumHeight: 50
            TextField {
                id: newGroupEdit
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.rightMargin: 10
                placeholderText: qsTr("Gruppenname")
                field.horizontalAlignment: Qt.AlignRight
                fontSize: Fonts.controlFontSize
                onAccepted: insertGroup()
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.minimumHeight: 50
            Layout.maximumHeight: 50

            StandardButton {
                text: width < 150 ? "" : qsTr("Gruppe anlegen")
                width: parent.width < deviceModel.count * 50 ? parent.width : deviceModel.count * 50
                anchors.verticalCenter: parent.verticalCenter
                icon: Icons.plus
                onClicked: insertGroup()
            }
        }

        InfoDialog {
            id: deleteGroupDialog
            property string groupID

            function openDialog(groupID) {
                deleteGroupDialog.groupID = groupID
                deleteGroupDialog.open()
            }

            anchors.centerIn: Overlay.overlay
            iconColor: Colors.warnRed
            icon: Icons.warning
            text: qsTr("Diese Gruppe ist möglicherweise mit vielen Benutzern verknüpft.Löschen der Gruppe führt dazu, dass allen mit dieser Gruppe verknüpften Nutzern Berechtigungen entzogen werden.\n\nDieser Vorgang kann nicht rückgängig gemacht werden!")

            StandardButton {
                text: qsTr("Löschen")
                fontColor: Colors.warnRed
                onClicked: {
                    groupModel.deleteItem(deleteGroupDialog.groupID)
                    onClicked: deleteGroupDialog.close()
                }
            }

            StandardButton {
                text: qsTr("Abbrechen")
                onClicked: deleteGroupDialog.close()
            }
        }
    }

    function insertGroup() {
        if (newGroupEdit.text.trim() !== "") {
            var data = {
                "name": newGroupEdit.text,
                "description": ""
            }
            groupModel.insert(data)
            newGroupEdit.text = ""
        } else {
            newGroupEdit.showErrorAnimation()
            newGroupEdit.forceActiveFocus()
        }
    }
}
