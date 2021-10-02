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

Item
{
    id: docroot
    height: rep.contHeight + 20
    width:rep.count * 50  + offset
    property int lableAngle: -50
    property color lineColor
    property int offset: 0.839 * height // tan(90 + lableAngle) * height

    Row
    {
        id: row
        height: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 6
        x: -15

        Item
        {
            width: 50
            height: 40
            rotation: docroot.lableAngle
            anchors.bottom: parent.bottom

            Rectangle
            {
                width: rep.totalHeight
                height: 1
                color: docroot.lineColor
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
            }
        }


        Repeater
        {
            id: rep
            model: deviceModel
            property int contHeight
            property int totalHeight
            function checkHeight()
            {
                for(var i = 0; i < count; i++)
                {
                    if(rep.itemAt(i) !== null)
                    {
                        rep.contHeight = Math.max(rep.contHeight, rep.itemAt(i).itemHeight)
                        rep.totalHeight = Math.max(rep.totalHeight, rep.itemAt(i).totalHeight)
                    }
                }
            }

            Component.onCompleted: checkHeight()

            Item
            {
                id: rotWrapper
                width: 50
                height: 40
                rotation: docroot.lableAngle
                anchors.bottom: parent.bottom
                property int itemHeight: label.width*Math.cos(docroot.lableAngle * Math.PI / 180 ) + 20

                property int totalHeight: label.width + 20

                //Rectangle{color:"red"; opacity: .2; anchors.fill: parent}
                TextLabel
                {
                    id: label
                    text: _displayName !== undefined ? _displayName : ""
                    onWidthChanged: rep.checkHeight()
                    fontSize:Fonts.controlFontSize

                    Rectangle
                    {
                        width: rep.totalHeight
                        height: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -11
                        color: docroot.lineColor
                    }
                }
            }
        }
    }
}
