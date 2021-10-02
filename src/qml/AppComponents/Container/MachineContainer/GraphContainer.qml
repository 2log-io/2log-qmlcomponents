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


import QtQuick 2.11
import UIControls 1.0
import QtQuick.Layouts 1.3
import CloudAccess 1.0
import AppComponents 1.0

import "../../Widgets"

Container
{
    id: docroot
    Layout.fillWidth: true
    Layout.minimumHeight: totalHeight
    Layout.maximumHeight: totalHeight

    property alias repaintInterval: chart.repaintInterval
    headline: qsTr("Ruhestrom-Schwellwert")
    helpText: qsTr("Der Ruhestrom-Schwellwert bestimmt, ab welchem Stromverbrauch das System davon ausgeht, dass die Maschine arbeitet. Nimm die Maschine in Betrieb und stelle den Schwellwert so ein, dass der Graph nur dann oberhalb der Linie ist, wenn die Maschine arbeitet.")
    property DevicePropertyModel current

    Binding on current
    {
        value: powModel.getProperty("curr")
    }

    property DeviceModel powModel
    property DeviceModel controllerModel

    property double threshold: controllerModel ?  controllerModel.getProperty("activityThreshold").value : 0
    onThresholdChanged: handle.y = chart.getYForValue(threshold)
    Component.onCompleted: chart.maxVal = threshold

    property double value: current.value !== undefined ? current.value : 0

    onValueChanged:
    {
        chart.addData(value)
    }


    RowLayout
    {
        id: layout
        width: parent.width
        height: 200
        spacing: 10

        Item
        {
            width: 60
            Layout.fillHeight: true

            Rectangle
            {
                id:handle
                y:0

                Behavior on y {NumberAnimation{easing.type:  Easing.OutQuad;} enabled: !handleArea.pressed}
                height: 40
                width: 60
                radius: 5
                color: Colors.greyBlue

                MouseArea
                {
                    id: handleArea
                    anchors.fill: parent
                    drag.target: parent
                    drag.axis: Drag.YAxis
                    drag.minimumY: 0
                    drag.maximumY: chart.height
                    onReleased:
                    {

                        controllerModel.getProperty("activityThreshold").value = chart.getValueForY(handle.y)
                    }
                }

                TextLabel
                {
                    anchors.centerIn: parent
                    fontSize:  Fonts.controlFontSize
                    Binding on text
                    {
                        delayed: true
                        value: (chart.maxVal > 0 && chart.height > 0) ? chart.getValueForY(handle.y).toFixed(2)+" A" : 0
                    }
                }

                Rectangle
                {
                    width: Layout.width

                }

                DottedLine
                {
                    dotColor: Colors.white
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: 4
                    dotSpacing: 6
                    dotSize: 1
                    width: chart.width + 10
                }
            }
        }

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true

            LineChart
            {
                id: chart

                lineColor: Colors.highlightBlue
                anchors.fill: parent
                anchors.topMargin: 20
                lineThickness: 1
                anchors.bottomMargin: 20
                onMaxChanged: handle.y = chart.getYForValue(docroot.threshold)

                SynchronizedListModel
                {
                    id: influxmodel
                    resource: "influxdb/"+powModel.resource+"$curr?last=5m"
                    onCountChanged:
                    {
                        for(var i = 0; i < count; i++)
                        {
                            var val = influxmodel.get(i).curr
                            chart.addData(val >= 0 ? val : 0, influxmodel.get(i).time, i === count-1)
                        }
                    }
                }

                Rectangle
                {
                    id: bottomLine
                    height: 2
                    anchors.bottom: parent.bottom
                    width: parent.width
                    color: Colors.white
                    opacity: .05
                }


                Rectangle
                {
                    width: 2
                    anchors.bottom:bottomLine.top
                    anchors.top: parent.top
                    anchors.left: parent.left
                    opacity: .05
                }
            }
        }
    }


    Flow
    {
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 70

        Row
        {
            Form
            {
                id: form1
                width: 145
                visible: controllerModel && controllerModel.hasProperty("activityTimeout")
                FormTextItem
                {
                    id: nameLabel
                    label:qsTr("Zeitliche Toleranz:")
                    Binding on text {value: controllerModel ? controllerModel.getProperty("activityTimeout").value / 1000 : ""}
                    validator:IntValidator{bottom: 0; top: 60}
                    onAccepted: if(controllerModel) controllerModel.getProperty("activityTimeout").value = editedText * 1000
                  //  mandatory: true
                }
            }
            TextLabel
            {
                visible: form1.visible
                text:"sek"
                fontSize:Fonts.smallControlFontSize
                anchors.verticalCenter: parent.verticalCenter
                color: Colors.grey

            }
        }

        Item
        {
            width: 30
            height: 10
        }

        Row
        {
            Form
            {
                id: form2
                width: 160
                visible: controllerModel && controllerModel.hasProperty("machineInitTime")
                FormTextItem
                {
                    label:qsTr("Initialisierungsdauer:")
                    Binding on text {value: controllerModel ? controllerModel.getProperty("machineInitTime").value / 1000 : ""}
                    validator:IntValidator{bottom: 0; top: 60}
                    onAccepted: if(controllerModel) controllerModel.getProperty("machineInitTime").value = editedText * 1000

                  //  mandatory: true
                }
            }
            TextLabel
            {
                visible: form2.visible
                text:"sek"
                anchors.verticalCenter: parent.verticalCenter
                fontSize:Fonts.smallControlFontSize
                color: Colors.grey
            }
        }
    }
}
