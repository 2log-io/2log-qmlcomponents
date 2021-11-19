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
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import UIControls 1.0
import CloudAccess 1.0

//Item
//{
//    height: layout.height
//    width: parent.width

    ColumnLayout
    {
        id: docroot
        signal cancel()
        property bool active: (StackView.status == StackView.Active)

        spacing: 10


        Item
        {

            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        TextField
        {
            id: id
            width: parent.width

            placeholderText: qsTr("Login")
            onAccepted: docroot.login(username.text, password.text)
            icon: Icons.user
            enabled: Connection.state !== Connection.STATE_Disconnected
        }


        StandardButton
        {
            width: parent.width
            text: qsTr("Passwort Zurücksetzen")
            onClicked:
            {
                var object =
                {
                    "userID": id.text
                }
                labService.call("resetPassword", object, function(data){docroot.cancel()})
            }

        }

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        StandardButton
        {
            transparent: true
            icon: Icons.leftAngle
            text: qsTr("Abbrechen")
            onClicked: docroot.cancel()
            opacity: docroot.active ? 1 : 0

            Behavior on opacity
            {
                NumberAnimation{ }
            }
        }

        ServiceModel
        {
            id: labService
            service: "lab"
        }

    }
//}
