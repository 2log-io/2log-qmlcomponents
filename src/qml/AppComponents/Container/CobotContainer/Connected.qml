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

    property string spaceURL
    signal next()


    Column
    {
        anchors.centerIn: parent
        spacing: 20

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            Image
            {
                source: "qrc:/Assets/Cobot.svg"
                sourceSize.height: 50
                y: 5

            }
        }

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            TextLabel
            {
                fontSize: 16
                font.family: Fonts.simplonMono
                text: spaceURL
            }
            Icon
            {
                icon: Icons.check
                anchors.verticalCenter: parent.verticalCenter
                iconColor: Colors.highlightBlue
                iconSize: 12
            }
        }

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            StandardButton
            {
                id:resSyncBtn
                text: qsTr("Lade Ressourcen")
                enabled: true
                icon: Icons.plug
                toolTipText: qsTr("Überträgt neu angelegte Ressourcen von Cobot nach 2log.")
                onClicked:
                {
                    cobotService.call("synchronizeResources", {}, synchronizeResourcesCb)
                    resSyncBtn.loading = true
                }

                function synchronizeResourcesCb(data)
                {
                    console.info("info completed")
                    resSyncBtn.loading = false
                }
            }

            StandardButton
            {
                id:userSyncBtn
                text: qsTr("Synchronisiere Benutzer")
                enabled: true
                icon: Icons.user
                toolTipText: "Überträgt neu angelegte Benutzer von Cobot nach 2log."
                onClicked:
                {
                    cobotService.call("synchronizeUsers", {}, synchronizeResourcesCb)
                    resSyncBtn.loading = true
                }

                function synchronizeResourcesCb(data)
                {
                    console.info("info completed")
                    resSyncBtn.loading = false
                }
            }
        }
        ServiceModel
        {
            id: cobotService
            service: "cobotservice"
        }
    }
}
