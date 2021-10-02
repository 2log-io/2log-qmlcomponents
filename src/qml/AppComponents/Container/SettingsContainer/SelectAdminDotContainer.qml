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


Container
{
    id: selectDot
    headline: "RFID Reader"
    width: parent.width
    property string selectedReaderMapping
    signal selectedReaderIndexChosen(string selectedReader)

    Item
    {
        FilteredDeviceModel
        {
            id: dotModel
            deviceType: ["2log Dot", "RFID Reader"]
        }
    }


    Flow
    {
        width: parent.width
        spacing: 20

        TextLabel
        {
            height: 40
            verticalAlignment: Qt.AlignVCenter
            id: label
            elide: Text.ElideNone
            wrapMode: Text.Wrap
            text: qsTr("Dot zum Anlegen und Editieren von Nutzern");
        }


        Row
        {
            id: stateDisplay
            spacing: 10

            DropDown
            {
                id: dotDropDown
                width: 200
                enabled: options.length > 0
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: enabled ? qsTr("Wähle einen Dot") : qsTr("Keine Dots registriert")
                options:
                {
                    var options = []
                    for(var i = 0; i < dotModel.count; i++)
                    {
                        var description = dotModel.getModelAt(i).description
                        if(description === "")
                            description = dotModel.getModelAt(i).uuid
                        options.push(description)
                    }
                    return options;
                }
                selectedIndex:
                {
                    if(dotModel.count > 0 )
                    {
                        var indexForMap = dotModel.getIndexForMapping(selectDot.selectedReaderMapping)
                        return indexForMap
                    }

                    return -1
                }

                onIndexClicked:
                {
                    var selectedReader = dotModel.getMapping(index)
                    if(selectedReader !== "")
                        settingsModel.setProperty("selectedReader", selectedReader)
                }
            }


            SynchronizedObjectModel
            {
                id: settingsModel
                resource: "home/settings/cardreader"
                onInitializedChanged:
                {
                    selectDot.selectedReaderMapping = Qt.binding(function()
                    {
                        var selectedreader = settingsModel.selectedReader
                        return selectedreader  === undefined ? "" : selectedreader
                    })
                }
            }
            property bool readerOnline:
            {
                if(dotModel.count == 0)
                    return false

                var index = dotDropDown.dirty ? dotDropDown.editedSelectedIndex : dotDropDown.selectedIndex

                 index >= 0 ? dotModel.getModelAt(index).deviceOnline : false
            }

            Item
            {
                width: 20
                height: 1
            }


            Icon
            {
                 id: icon
                 anchors.verticalCenter: parent.verticalCenter
            }

            TextLabel
            {
                id: stateText
                anchors.verticalCenter: parent.verticalCenter
            }

            states:
            [
                State
                {
                    name:"online"
                    when: stateDisplay.readerOnline
                    PropertyChanges
                    {
                        target: icon
                        icon: Icons.check
                    }

                    PropertyChanges
                    {
                        target: stateText
                        text: "Bereit"
                    }
                },
                State
                {
                    name:"offline"
                    when: !stateDisplay.readerOnline
                    PropertyChanges
                    {
                        target: icon
                        icon: Icons.warning
                        iconColor: Colors.warnRed
                    }

                    PropertyChanges
                    {
                        target: stateText
                        text: "Offline"
                    }
                }
            ]
        }
    }
}
