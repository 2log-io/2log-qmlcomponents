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
import CloudAccess 1.0
import AppComponents 1.0

Item
{
    id: docroot
    property var model
    property int hoveredIndex: -1
    property int total: rep.sum
    signal itemHovered(int index)

    Repeater
    {
        id: rep
        model: docroot.model

        property int sum
        onModelChanged:
        {
            var sum = 0
            for(var i = 0; i < rep.count; i ++)
            {
                console.log(rep.model[i].value)
                sum += rep.model[i].value
            }

            rep.sum = sum
        }

        property int nettoRot: 360 - (rep.count * 2)

        Arc
        {
            property real angle:  rep.sum == 0 ? 0 : (modelData.value / rep.sum) * rep.nettoRot
            anchors.fill: parent
            color: docroot.hoveredIndex == index ? Colors.highlightBlue : Colors.white
            thickness: 20
            startAngle: index > 0 ? rep.itemAt(index -1).endAngle + 2 : 0
            endAngle: startAngle + ( angle < 1 ? 1 : angle)
            Behavior on color {ColorAnimation {}}
            property bool containsMouse: isIn(area.mouseX, area.mouseY) && area.containsMouse
            onContainsMouseChanged:
            {
                if(containsMouse)
                {
                    docroot.itemHovered(index)
                    docroot.hoveredIndex = index
                }
                else
                {
                    docroot.itemHovered(-1)
                    docroot.hoveredIndex = -1
                }
            }
        }
    }

    MouseArea
    {
        id: area
        anchors.fill: parent
        hoverEnabled: true
    }
}
