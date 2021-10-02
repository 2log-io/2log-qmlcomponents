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
import "../Statistics"

Container
{
    id: docroot
    headline:qsTr("Status")
    width: parent.width
    Layout.minimumHeight: totalHeight
    Layout.maximumHeight: totalHeight
    property alias repaintInterval: graphValueBox.repaintInterval
    property bool allOkay: pow.available && pow.deviceOnline && reader.available && reader.deviceOnline
    property DeviceModel controller
    property DeviceModel pow
    property DeviceModel reader

    Column
    {
        width:parent.width
        spacing: docroot.spacing
        Flow
        {
            id: flow
            width: parent.width
            spacing: docroot.spacing

            BaseValueBox
            {
                id: switchStateContainer
                width: responsiveStates.itemWidth
                height: 120
                label: qsTr("Maschine sperren")

                Row
                {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 10
                    spacing: 20


                    Icon
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        icon: Icons.lockClosed
                        iconColor: !controller.getProperty("enabled").value ? Colors.warnRed : Colors.white_op50
                    }


                    ToggleSwitch
                    {
                        checkable: false
                        Binding on checked
                        {
                            value: controller ? controller.getProperty("enabled").value : false
                        }

                        onIcon: Icons.check
                        offIcon:Icons.cancel
                        onColor: Colors.white
                        offColor: Colors.white

                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: controller.getProperty("enabled").value  = !controller.getProperty("enabled").value
                    }

                    Icon
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        icon: Icons.lockOpen
                        iconColor:controller.getProperty("enabled").value ? Colors.highlightBlue : Colors.white_op50
                    }

//                    TextLabel
//                    {
//                        anchors.verticalCenter: parent.verticalCenter
//                        anchors.topMargin: 20
//                        text:controller && !controller.getProperty("enabled").value  ? qsTr("Aktiv") : qsTr("Inaktiv")
//                        fontSize: Fonts.bigDisplayFontSize
//                        width: 115
//                    }
                }
            }

            StatusValueBox
            {
                id: statusContainer
                width: responsiveStates.itemWidth
                dotState:
                {
                    if(!reader.available)
                        return -1

                    if(!reader.deviceOnline)
                        return -2

                    return 0;
                }
                switchState: {
                    if(!pow.available)
                        return -1

                    if(!pow.deviceOnline)
                        return -2

                    return 0;
                }
            }

            ValueBox
            {
                id: powerContainer
                width: responsiveStates.itemWidth
                label: qsTr("Stromverbrauch (24h)")
                unit: "kW/h"
                value:
                {
                    var val = influxModel.initialized ? (((influxModel.curr * 230) / 1000) * 24) : 0 //pow.getProperty("curr").value
                    return val > 0 ? val.toFixed(2) : 0
                }
            }

            SynchronizedObjectModel
            {
                id: influxModel
                resource: "influxdb/"+pow.resource+"$curr?last=24h"
            }

        }

        GraphValueBox
        {
            id: graphValueBox
            powModel: docroot.pow
            width: flow.width
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
                when: flow.width < 800 && docroot.allOkay
                PropertyChanges
                {
                    target: statusContainer
                    visible: false
                }
            },

            State
            {
                name:"maintainance"
                when: flow.width < 800 &&  !controller.enabled
                PropertyChanges
                {
                    target: powerContainer
                    visible: false
                }
            },

            State
            {
                name:"dotOffline"
                when: flow.width < 800 &&  !reader.deviceOnline

                PropertyChanges
                {
                    target: switchStateContainer
                    visible: false
                }
            },
            State
            {
                name:"switchOffline"
                when: flow.width < 800 &&  !pow.deviceOnline

                PropertyChanges
                {
                    target: powerContainer
                    visible: false
                }
            }
        ]
    }
}
