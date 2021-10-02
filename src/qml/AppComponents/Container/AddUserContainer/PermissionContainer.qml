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
import QtQuick.Layouts 1.3
import CloudAccess 1.0
import AppComponents 1.0
import "../../Widgets"


Container
{
    id: container

    headline:qsTr("Berechtigungen")
    property var permissions:({})
    property var groups:({})


    function check(deviceID)
    {
        if(allgroupsModel.count <= 0)
            return false;
        for(var i = 0; i < allgroupsModel.keys.length; i++)
        {
            var key = allgroupsModel.keys[i]
            var item = groups[key]
            if(item !== undefined)
            {
                if(item.active)
                {
                    var entities = allgroupsModel.getItem(key).entities
                    for(var n = 0; n < entities.length; n++)
                    {
                        if(entities[n].entityID === deviceID)
                            return true;
                    }
                }
            }
        }
        return false;
    }


    Column
    {
        width: parent.width
        spacing: 10


        TextLabel
        {
            visible: layout.count > 0
            text:qsTr("Gruppenberechtigungen")
            opacity: .5
        }

        SynchronizedListLookupModel
        {
            id: allgroupsModel
            lookupKey:"uuid"
            resource:"labcontrol/groups"
        }

        DynamicGridView
        {
            id: layout
            width: parent.width + 10
            cellHeight: 150
            maxCellWidth: 160
            model: allgroupsModel.keys
            interactive:false

            delegate:
            Item
            {
                width: layout.cellWidth
                height: layout.cellHeight

                GroupPermissionItem
                {
                    id: item
                    property var permission: container.groups[allgroupsModel.getItem(modelData).uuid]
                    anchors.fill: parent
                    anchors.bottomMargin: 10
                    anchors.rightMargin:  10
                    deviceName: allgroupsModel.getItem(modelData).name
                    expires: permission !== undefined ? permission.expirationDate : ""
                    permissionState:
                    {
                        return permission === undefined ? 0 : 1
                    }
                    onClicked:
                    {
                        container.groups = addOrRemoveGroup(allgroupsModel.getItem(modelData).uuid, container.groups)
                    }

                    onDateSelected: container.groups = setPermissionDate(allgroupsModel.getItem(modelData).uuid, container.groups, date)
                }
            }
        }

        TextLabel
        {
            text:qsTr("Einzelberechtigungen")
            opacity: .5
        }


        DynamicGridView
        {
            id: layout2
            width: parent.width + 10
            maxCellWidth: 160
            cellHeight: 150
            model: deviceModel
            interactive:false

            delegate:
            Item
            {
                width: layout.cellWidth
                height: layout.cellHeight

                SinglePermissionItem
                {
                    id: item2
                    property var permission: container.permissions[_deviceID]
                    anchors.fill: parent
                    icon: TypeDef.getIcon(_tag)
                    anchors.bottomMargin: 10
                    anchors.rightMargin:  10
                    deviceName:  _displayName
                    expires: permission !== undefined ? permission.expirationDate : ""

                    permissionState:
                    {
                        if(permission === undefined)
                            return 0;

                        if(permission.active)
                            return 1
                        else
                            return 2
                    }

                    hasGroupPermission:
                    {
                        container.check(_deviceID)
                    }

                    onClicked: container.permissions = setPermissionState(_deviceID, container.permissions, (permissionState + 1) % 3)
                    onSetLevel: container.permissions = setPermissionState(_deviceID, container.permissions, level)
                    onDateSelected: container.permissions = setPermissionDate(_deviceID, container.permissions, date)
                }
            }
        }
    }


    function setPermissionDate(permissionID, permissions, date)
    {
        if(permissions[permissionID] !== undefined)
        {
            permissions[permissionID].expirationDate = date
            return permissions
        }

    }
    function setPermissionState(permissionID, permissions, state)
    {
        if(state === 0 && permissions[permissionID] !== undefined)
        {
            delete permissions[permissionID]
            return permissions;
        }
        else
        {

            if(permissions[permissionID] !== undefined)
            {
                permissions[permissionID].active = (state === 1)
                return permissions
            }

            var now = new Date()
            now.setFullYear(now.getFullYear()+1)
            var permission = {}
            permission["expirationDate"] = now
            permission["active"] = (state === 1)
            permission["expires"] = true
            permission["resourceID"] = permissionID
            permissions[permissionID] = permission
            return permissions
        }
    }

    function addOrRemovePermission(permissionID, permissions)
    {
        if(permissions[permissionID] === undefined)
        {
            var now = new Date()
            now.setFullYear(now.getFullYear()+1)
            var permission = {}
            permission["expirationDate"] = now
            permission["active"] = true
            permission["expires"] = true
            permission["resourceID"] = permissionID
            permissions[permissionID] = permission
        }
        else
        {
            delete permissions[permissionID]
        }

        return permissions
    }

    function addOrRemoveGroup(groupID, groups)
    {
        if(permissions[groupID] === undefined)
        {
            var now = new Date()
            now.setFullYear(now.getFullYear()+1)
            var permission = {}
            permission["expirationDate"] = now
            permission["active"] = true
            permission["expires"] = true
            permission["groupID"] = groupID
            groups[groupID] = permission
        }
        else
        {
            delete permissions[groupID]
        }

        return permissions
    }

}
