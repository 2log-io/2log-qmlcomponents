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
import QtQuick.Controls 2.0
import CloudAccess 1.0
import QtQuick.Layouts 1.12
import UIControls 1.0
import AppComponents 1.0
import "../Statistics"


BaseValueBox
{
    id: docroot
    label: qsTr("Stromsignatur")

    property alias repaintInterval: chart.repaintInterval
    property bool hasNoData:  chart.maxVal < 0.001 || influxmodel.count < 3
    property DeviceModel powModel

    property DevicePropertyModel current

    Binding on current
    {
        value: powModel.getProperty("curr")
    }
    property double value: current.value !== undefined ? current.value : 0

    onValueChanged:
    {
        chart.addData(value)
    }


    property double max

    SynchronizedListModel
    {
        id: influxmodel
        resource: "influxdb/"+powModel.resource+"$curr?last=1h"
        onCountChanged:
        {
            for(var i = 0; i < count; i++)
            {
                var val = influxmodel.get(i).curr
                chart.addData(val >= 0 ? val : 0, influxmodel.get(i).time, i === count-1)
            }

        }
    }

    Item
    {
        anchors.fill: parent
        anchors.topMargin: 40
        anchors.margins: 10
        anchors.bottomMargin: 40


        LineChart
        {
            id: chart
            visible: !docroot.hasNoData
            anchors.rightMargin: hasNoData ? 0 : 130
            anchors.fill: parent
            lineColor: Colors.highlightBlue
            lineThickness: 1

            Rectangle
            {
                id: bottomLine
                height: 2
                anchors.top: parent.bottom
                width: parent.width
                color: Colors.white
                opacity: .05
                visible: !hasNoData
            }


            Rectangle
            {
                width: 2
                visible: !hasNoData
                anchors.bottom:bottomLine.top
                anchors.top: parent.top
                anchors.left: parent.left
                opacity: .05
            }
        }

        TextLabel
        {
            anchors.left: chart.right
            anchors.leftMargin: 10
            visible: !hasNoData
            Behavior on y {NumberAnimation{}}
            text:powModel.available && powModel.deviceOnline ? docroot.value.toFixed(2) +" A" : ""
            fontSize: Fonts.bigDisplayFontSize
            y: (influxmodel.count > 0 ? chart.getYForValue(docroot.value) : 0) -height/2
        }
    }
    //height: 540

    Column
    {
        anchors.centerIn: parent
        visible:hasNoData
        spacing: 5
        TextLabel
        {
            text: qsTr("Keine Daten")
            anchors.horizontalCenter:   parent.horizontalCenter
            fontSize: Fonts.bigDisplayFontSize
            opacity: .2
        }
    }
}
