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
import QtQuick.Controls 2.3
import UIControls 1.0
import CloudAccess 1.0

Item
{
    id: docroot

    property bool active: (StackView.status == StackView.Active)

    signal confirm()
    signal cancel()

    Column
    {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -20
        spacing: 10

        TextLabel
        {
            text:qsTr("Möchtest du die Verbindung zu ServerEye trennen?")
            font.styleName: "Bold"
            fontSize: Fonts.subHeaderFontSize
        }
        TextLabel
        {
            text:qsTr("Alle Sensoren werden in ServerEye gelöscht.\n"
                      +"Dieser Vorgang kann nicht rückgängig gemacht werden!")
        }
    }

    StandardButton
    {
        id: confirmButton

        icon: Icons.disconnect
        visible: opacity > 0
        opacity: docroot.active ? 1 : 0
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        iconColor: Colors.warnRed
        text: qsTr("Trennen")
        onClicked:
        {
            var data = {}
            servereyeService.call("disconnect", data, disconnectCb)
        }


        function disconnectCb(data)
        {
        }

        Behavior on opacity
        {
            NumberAnimation{ }
        }
    }

    ServiceModel
    {
        id: servereyeService
        service: "servereye"
    }

    StandardButton
    {
        transparent: true
        icon: Icons.leftAngle
        text: qsTr("Abbrechen")
        anchors.bottom: parent.bottom
        onClicked: docroot.cancel()
        opacity: docroot.active ? 1 : 0

        Behavior on opacity
        {
            NumberAnimation{ }
        }
    }
}
