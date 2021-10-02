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
import "../../Widgets"
import CloudAccess 1.0

Item
{
    id: docroot

    property string groupID
    property SynchronizedListLookupModel groupLookupModel
    property var groupObject: groupLookupModel.getItem(groupID)
    property color lineColor
    width: rep.count * 50
    signal deleteGroup(string groupID)

    height: 50

    Row
    {
        id: row
        height: parent.height
        SynchronizedListLookupModel
        {
            id: entityModel
            resource: "labcontrol/groups/entities/"+modelData
            lookupKey:"entityID"
        }


        Rectangle
        {
            width: 1
            color:docroot.lineColor
            height: parent.height
        }

        Repeater
        {
            id: rep
            model: deviceModel.count

            Item
            {
                id: delegate
                height: 50
                width: 50

                property bool containsDevice: groupObject.entities.find(checkItem) !== undefined
                function checkItem(item){return item.entityID === deviceID;}
                property string deviceID
                Binding on deviceID
                {
                   value: deviceModel.getModelAt(index).deviceID
                }

                Rectangle
                {
                    width: 1
                    color:docroot.lineColor
                    height: parent.height
                    anchors.right: parent.right
                }

                Icon
                {
                    id: icon
                     icon: Icons.no
                     anchors.centerIn: parent
                     visible: true
                     iconColor: Colors.white
                     opacity: .1
                     states:
                     [
                         State
                         {
                            name:"checked"
                            when:  delegate.containsDevice
                            PropertyChanges
                            {
                                icon: Icons.check
                                target: icon
                                opacity: 1
                                iconColor: Colors.highlightBlue
                                visible: true
                            }
                         },
                         State
                         {
                            name:"hover"
                            when: checkBoxMouseArea.containsMouse
                            PropertyChanges
                            {
                             //   icon: Icons.check
                                opacity: .5
                                target: icon
                                visible: true
                            }
                         }
                     ]

                }

                MouseArea
                {
                    id: checkBoxMouseArea
                     anchors.fill: parent
                     hoverEnabled: true
                     onHoveredChanged:deleteButton.visible = containsMouse
                     onClicked:
                     {
                        if(entityModel.contains(delegate.deviceID))
                        {
                            entityModel.deleteItem(delegate.deviceID)
                        }
                        else
                        {
                            entityModel.insert({"entityID":delegate.deviceID, "entityType":"device"})
                        }
                     }
                }
            }
        }

        Item
        {
            id: deleteButton
            height: 50
            width: 50
            visible: false

            Icon
            {
                id: icon
                 anchors.centerIn: parent
                 icon: Icons.trash
                 iconColor: Colors.warnRed
            }

            MouseArea
            {
                 anchors.fill: parent
                 hoverEnabled: true
                 onHoveredChanged: deleteButton.visible = containsMouse
                 onClicked: docroot.deleteGroup(modelData)
            }
        }
    }
}
