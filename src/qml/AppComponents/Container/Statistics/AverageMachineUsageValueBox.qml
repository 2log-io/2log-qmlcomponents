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
import QtQuick.Layouts 1.12
import UIControls 1.0

BaseValueBox
{
    id: docroot

    property var model
    property double max
    //height: 540

    label: qsTr("Durchschnittliche Session-Zeit")

    onModelChanged:
    {
        if (!model || model === undefined)
            return

        var max = 0
        for(var i = 0; i < docroot.model.length; i ++)
        {
            max = Math.max(docroot.model[i].value, max)
        }

        docroot.max = max
    }

    Column
    {
        anchors.centerIn: parent
        visible: rep2.count == 0

        spacing: 5
        TextLabel
        {
            text: qsTr("Keine Daten")
            anchors.horizontalCenter:   parent.horizontalCenter
            fontSize: Fonts.bigDisplayFontSize
            opacity: .2
        }

        TextLabel
        {
            text: qsTr("im ausgewählten Zeitfenster")
            anchors.horizontalCenter:  parent.horizontalCenter
            fontSize: Fonts.headerFontSze
            opacity: .2
        }
    }

    Flickable
    {
        anchors.fill: parent
        anchors.topMargin: 40
        anchors.margins: 20
        contentHeight: grid.height
        clip: true


        GridLayout
        {
            id: grid

            width: parent.width
            rowSpacing: 0
            columnSpacing: 14

            Repeater
            {
                id: rep2
                model: docroot.model
                delegate:
                TextLabel
                {
                    verticalAlignment: Qt.AlignVCenter
                    text:(docroot.model[index].value / 1000 / 60).toFixed(1)+"m"
                    Layout.alignment: Qt.AlignVCenter
                    Layout.minimumHeight: 40
                    Layout.row: index
                    Layout.column: 2
                }
            }

            Repeater
            {
                id: rep3
                model: docroot.model
                delegate:
                Item
                {
                    height: 16
                    Layout.row: index
                    Layout.column: 1
                    Layout.fillWidth: true
                    Rectangle
                    {
                        height: parent.height
                        width: parent.width * (modelData.value / docroot.max)
                    }
                }
            }

            Repeater
            {
                id: rep1
                model: docroot.model
                delegate:
                TextLabel
                {
                    Layout.minimumHeight: 40
                    verticalAlignment: Qt.AlignVCenter
                    text:
                    {
                        var model =  deviceModel.getDeviceModel(modelData._id.resourceID)
                        if(!model)
                            return  modelData._id.resourceID

                        var txt = model.displayName
                        return txt
                    }
                    Layout.row: index
                    Layout.column: 0
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                }
            }
        }
    }

}
