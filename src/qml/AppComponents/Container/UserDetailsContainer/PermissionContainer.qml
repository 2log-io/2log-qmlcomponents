

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
import AppComponents 1.0

Container {
    id: container
    width: parent.width

    headline: qsTr("Berechtigungen")
    property string userID
    property var permissions: ({})
    property bool bindingHelper
    clip: true

    function check(deviceID) {
        var x = container.bindingHelper
        for (var i = 0; i < allgroupsModel.keys.length; i++) {
            var key = allgroupsModel.keys[i]
            var item = groupModel.getItem(key)
            if (item._exists) {
                if (item.active) {
                    var entities = allgroupsModel.getItem(key).entities
                    for (var n = 0; n < entities.length; n++) {
                        if (entities[n].entityID === deviceID)
                            return true
                    }
                }
            }
        }
        return false
    }

    Item {
        height: 150
        width: parent.width
        property bool loading: !groupModel.initialized
                               || !allgroupsModel.initialized
                               || !permModel.initialized //|| !deviceModel.initialized
        Behavior on height {
            NumberAnimation {
                easing.type: Easing.OutQuad
                duration: 300
            }
        }
        onLoadingChanged: if (!loading)
                              timer.running = true

        LoadingIndicator {
            id: loadingIndicator
        }

        Timer {
            id: timer
            interval: 50
            repeat: false
            onTriggered: {
                parent.height = Qt.binding(function () {
                    return column.height
                })
                loadingIndicator.visible = false
                column.opacity = 1
            }
        }

        Column {
            opacity: 0
            Behavior on opacity {
                NumberAnimation {}
            }
            id: column
            width: parent.width
            spacing: 10

            TextLabel {
                text: qsTr("Gruppenberechtigungen")
                opacity: .5
                visible: groupPermLayout.count > 0
            }

            DynamicGridView {
                id: groupPermLayout
                width: parent.width + 10
                interactive: false
                cellHeight: 150
                maxCellWidth: 160
                model: container.userID !== ""
                       && allgroupsModel.count !== 0 ? allgroupsModel.keys : 0

                SynchronizedListLookupModel {
                    id: allgroupsModel
                    lookupKey: "uuid"
                    resource: "labcontrol/groups"
                }

                SynchronizedListLookupModel {
                    id: groupModel
                    resource: "labcontrol/users/groups/" + container.userID
                    lookupKey: "groupID"
                    keepDeletedItems: true
                    onKeysChanged: container.bindingHelper = false
                }

                Timer {
                    interval: 300
                    onTriggered: container.bindingHelper = false
                    repeat: false
                }

                delegate: Item {
                    width: groupPermLayout.cellWidth
                    height: groupPermLayout.cellHeight

                    GroupPermissionItem {
                        id: groupItem
                        anchors.fill: parent
                        onClicked: toggleGroup(modelData)
                        anchors.bottomMargin: 10
                        anchors.rightMargin: 10
                        expires: groupModel.getItem(modelData).expirationDate
                                 !== undefined ? groupModel.getItem(
                                                     modelData).expirationDate : ""
                        deviceName: allgroupsModel.getItem(modelData).name

                        onDateSelected: {
                            var item = groupModel.getItem(modelData)
                            item["expires"] = true
                            item.expirationDate = date
                        }

                        permissionState: {
                            container.bindingHelper = false
                            var groupItem = groupModel.getItem(modelData)
                            if (groupModel.getItem(modelData)._exists) {
                                if (groupModel.getItem(modelData).active)
                                    return 1
                                else
                                    return 0
                            } else
                                return 0
                        }
                    }
                }
            }

            TextLabel {
                text: qsTr("Einzelberechtigungen")
                opacity: .5
            }

            DynamicGridView {
                id: layout

                SynchronizedListLookupModel {
                    id: permModel
                    resource: "labcontrol/users/permissions/" + container.userID
                    lookupKey: "resourceID"
                    keepDeletedItems: true
                }

                width: parent.width + 10
                interactive: false
                cellHeight: 160
                maxCellWidth: 160

                model: container.userID !== ""
                       && groupModel.initialized ? deviceModel : 0

                delegate: Item {
                    width: layout.cellWidth
                    height: layout.cellHeight

                    property var permissionData: permModel.getItem(_deviceID)

                    SinglePermissionItem {
                        id: item
                        anchors.fill: parent
                        anchors.bottomMargin: 10
                        anchors.rightMargin: 10
                        hasGroupPermission: {
                            container.bindingHelper
                            container.check(_deviceID)
                        }
                        deviceName: _displayName
                        onSetLevel: setPermission(_deviceID, level)
                        expires: Date.fromLocaleDateString(
                                     parent.permissionData.expirationDate
                                     !== undefined ? parent.permissionData.expirationDate : "")
                        permissionState: {
                            if (permissionData._exists) {
                                if (permissionData.active)
                                    return 1
                                else
                                    return 2
                            } else
                                return 0
                        }

                        iconImage: TypeDef.getMachineIconSource(
                                       deviceModel.getDeviceModel(
                                           _deviceID).tag)
                        onClicked: setPermission(_deviceID,
                                                 (permissionState + 1) % 3)
                        onDateSelected: {
                            var item = permModel.getItem(_deviceID)
                            //item["expires"] = true
                            item.expirationDate = date
                        }
                    }
                }
            }
        }
    }

    function setPermission(deviceID, level) {
        if (level === 0) {
            if (permModel.contains(deviceID))
                permModel.deleteItem(deviceID)

            return
        }

        var permissionData = permModel.getItem(deviceID)
        if (permModel.contains(deviceID)) {
            permissionData.active = (level === 1)
            return
        } else {
            var now = new Date()
            now.setFullYear(now.getFullYear() + 1)
            var permission = {}
            permission["expirationDate"] = now
            permission["active"] = (level === 1)
            permission["expires"] = true
            permission["resourceID"] = deviceID
            permModel.insert(permission)
        }
    }

    function toggleGroup(groupID) {
        var groupData = groupModel.getItem(groupID)
        if (groupModel.contains(groupID)) {
            groupData.active = !groupData.active
        } else {
            var now = new Date()
            now.setFullYear(now.getFullYear() + 1)
            var permission = {}
            permission["expirationDate"] = now
            permission["active"] = true
            permission["expires"] = true
            permission["groupID"] = groupID
            groupModel.insert(permission)
        }
    }
}
