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
import UIControls 1.0
import QtQuick.Layouts 1.3
import "../../Widgets"


Container
{
    id: docroot
    headline: qsTr("Status")
    width: parent.width
    Layout.minimumHeight: totalHeight
    Layout.maximumHeight: totalHeight
    property DeviceModel controller
    property DeviceModel pow

    states:
    [
        State
        {
            name: "allOffline"
            when: !pow.deviceOnline
            PropertyChanges
            {
                target: statusIcon
                iconColor: Colors.warnRed
                icon: Icons.offline
            }

            PropertyChanges
            {
                target: statusText
                text: "offline"
                horizontalAlignment: Text.AlignHCenter
            }
        },
        State
        {
            name: "switchOffline"
            when: !pow.deviceOnline
            PropertyChanges
            {
                target: statusIcon
                iconColor: Colors.warnRed
                icon: Icons.offline
            }

            PropertyChanges
            {
                target: statusText
                text: "switch off"
                horizontalAlignment: Text.AlignHCenter
            }
        }
    ]

    Flow
    {
        id: flow
        width: parent.width
        spacing:  docroot.spacing


        Item
        {
            id: statusContainer
            width: responsiveStates.itemWidth
            height: 120


            Rectangle
            {
                anchors.fill: parent
                color:"white"
                opacity: .05

            }

            TextLabel
            {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                text: qsTr("Status")
                opacity: .5
            }

            Row
            {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 10
                spacing: 20

                Icon
                {
                    id: statusIcon
                    iconSize: 40
                    icon: Icons.check
                    iconColor: Colors.white_op50
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextLabel
                {
                    id: statusText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.topMargin: 20
                    text: "Bereit"
                    fontSize: Fonts.bigDisplayFontSize
                }
            }
        }


        Item
        {
            id: currentContainer
            width: responsiveStates.itemWidth
            height: 120

            Rectangle
            {
                anchors.fill: parent
                color:"white"
                opacity: .05
            }

            TextLabel
            {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                text: qsTr("Stromverbrauch")
                opacity: .5
            }

            Row
            {
                opacity: pow.deviceOnline ? 1 : .5
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 10
                spacing: 20

                Icon
                {
                    id: iconr
                    iconSize: 40
                    icon: Icons.blizzard
                    iconColor: Colors.white_op50
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextLabel
                {
                    property real currrent
                    width: 100
                    Binding on currrent
                    {

                        value:
                        {
                            var val = pow.getProperty("curr").value
                            return val ? val.toFixed(2) : 0
                        }
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.topMargin: 20
                    text: (currrent > 0 ? currrent : 0) + " A"
                    fontSize: Fonts.bigDisplayFontSize
                    horizontalAlignment: Qt.AlignRight
                }
            }
        }
    }

    Item
    {
        id: responsiveStates
        property int itemWidth:
        {
            var width = (flow.width - (flow.visibleChildren.length-1) * flow.spacing)  / flow.visibleChildren.length
            return width < 250 ? flow.width :  width
        }

        states:
        [
            State
            {
                name:"ready"
                when: flow.width < 800 && docroot.state == ""
                PropertyChanges
                {
                    target: statusContainer
                    visible: false
                }
            },

            State
            {
                name:"switchOffline"
                when: flow.width < 800 &&  !pow.deviceOnline

                PropertyChanges
                {
                    target: currentContainer
                    visible: false
                }
            }
        ]
    }
}
