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
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import CloudAccess 1.0
import AppComponents 1.0

GridLayout
{
    columns: 2
    rowSpacing: 5
    columnSpacing: 10

    property DeviceModel deviceModel

    TextLabel
    {
        visible: ipLabel.shortID !== ""
        color: Colors.grey
        text: "ID"
        fontSize: Fonts.verySmallControlFontSize
    }

    TextLabel
    {
        id: idlabel
        text: deviceModel.shortID
        Layout.fillWidth: true
        font.styleName: "Bolt"
        font.family: Fonts.simplonMono
        fontSize: 24
    }

    TextLabel
    {
        visible: ipLabel.text !== ""
        color: Colors.grey
        text: "IP"
        fontSize: Fonts.verySmallControlFontSize
    }

    TextLabel
    {

        id: ipLabel
        text:
        {
            var val = deviceModel.getProperty("ip").value
            return val ? val : ""
        }
        font.family: Fonts.simplonMono
        fontSize: Fonts.verySmallControlFontSize
        font.styleName: "Light"
    }

    TextLabel
    {
        visible: macLabel.text !== ""
        color: Colors.grey
        text: "MAC"
        fontSize: Fonts.verySmallControlFontSize
    }

    TextLabel
    {
        id: macLabel
        text:
        {
            var val = deviceModel.getProperty("mac").value
            return val ? val : ""
        }
        font.family: Fonts.simplonMono
        fontSize: Fonts.verySmallControlFontSize
        font.styleName: "Light"
    }
}
