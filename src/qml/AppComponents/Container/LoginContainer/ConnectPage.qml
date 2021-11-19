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


Item
{

    Column
    {
        id: docroot
        spacing: 0
        anchors.top: parent.top
        anchors.topMargin: 20
        width: parent.width

        function connect()
        {
            if(server.text !== "")
            {
                if(!server.text.includes(".") && !server.text.includes(":"))
                    server.text = server.text + ".2log.io"

                if(!server.text.startsWith("ws"))
                    server.text = "wss://"+server.text

                Connection.connectToServer(server.text, connectCb)
            }
            else
            {
                server.showErrorAnimation()
            }
        }

        function connectCb(success, errorMsg)
        {
            if(!success)
            {
                if(errorMsg === 0)
                    errorLabel.text = qsTr("Ungültige Server Adresse.")
                else
                    errorLabel.text = qsTr("Server Fehler.")

                error.opacity = 1
                server.showErrorAnimation()
            }
            else
            {
                errorLabel.text = ""
            }
        }

        TextField
        {
            id: server
            placeholderText: qsTr( "Server" )
            width: parent.width
            icon: Icons.server
            text:serverURL
            enabled: (Connection.state == Connection.STATE_Disconnected
                     && !root.suspended
                     && !root.provisioning) || errorLabel.text !== ""

            onTextChanged: if(text !== "") error.opacity = 0
            field.onAccepted:
            {
                docroot.connect()
            }
        }
        Item
        {
            id: error
            width: parent.width
            height: 1
            Behavior on opacity{NumberAnimation{}}
            opacity: 0

            TextLabel
            {
                id: errorLabel
                color: Colors.red
                y: -5
                fontSize: 14

            }
        }

        Item
        {
            height: 25
            width: parent.width
        }

        StandardButton
        {
            width: parent.width
            text: qsTr("Verbinden")
            onClicked:
            {
                 docroot.connect()
            }
        }
    }
}
