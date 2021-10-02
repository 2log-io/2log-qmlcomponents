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

Item
{
    id: docroot

    property string label
    property string helpText

    width: parent.width > 850 ? (parent.width - 20) / 2 : parent.width
    height: 260


    Rectangle
    {
        anchors.fill: parent
        color:"white"
        opacity: .05
        radius:3
    }

    Row
    {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10
        height: text.height
        TextLabel
        {
            id: text
            text: docroot.label
            opacity: .5
        }

        HelpTextFlyout
        {
            height: parent.height
            width: 30
            helpText: docroot.helpText
        }
    }
}
