

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

BaseValueBox {
    id: docroot
    width: 200
    height: 120

    property int value
    property var formattedValue: HelperFunctions.formatMillis(value)
    property bool hasHours: value >= 60 * 60 * 1000

    Row {
        spacing: 5
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 10

        TextLabel {
            id: hours
            visible: docroot.hasHours
            anchors.verticalCenter: parent.verticalCenter
            text: docroot.value < 0 ? "0" : docroot.formattedValue.hours
            fontSize: Fonts.bigDisplayFontSize
        }

        TextLabel {
            visible: docroot.hasHours
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 5
            text: qsTr("h")
            color: Colors.grey
            opacity: .4
            fontSize: Fonts.bigDisplayUnitFontSize
        }

        Item {
            visible: docroot.hasHours
            width: 5
            height: parent.height
        }

        TextLabel {
            id: minutes
            anchors.verticalCenter: parent.verticalCenter
            text: docroot.value < 0 ? "0" : docroot.formattedValue.minutes
            fontSize: Fonts.bigDisplayFontSize
        }

        TextLabel {
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 5
            text: qsTr("min")
            color: Colors.grey
            opacity: .4
            fontSize: Fonts.bigDisplayUnitFontSize
        }
    }
}
