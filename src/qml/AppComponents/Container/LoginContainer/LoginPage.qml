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

Column
{
    id: docroot
    onLogin: UserLogin.login(username, password, loginCb, true)
     //width: parent.width
    spacing: 10

    signal login(string username, string password)
    signal resetPasswordClicked()

    property bool showForgetField: !(username.text !== "" || password.text !== "")
    property bool active: StackView.status === StackView.Active
    onActiveChanged: if(active) username.forceActiveFocus()
    FocusScope{id: dummy}
    function loginCb(login)
    {
        if(!login)
        {
            password.text = ""
            shakeAnimation.start()
        }
    }

    TextField
    {
        id: username
        enabled: Connection.state != Connection.STATE_Authenticated
        width: parent.width
        placeholderText: qsTr( "Login" )
        nextOnTab:  password.field
        icon: Icons.user
    }

    TextField
    {
        id: password
        width: parent.width
        placeholderText: qsTr("Password")
        field.echoMode: TextInput.Password
        enabled: Connection.state != Connection.STATE_Authenticated
        onAccepted:
        {
            if(Connection.state == Connection.STATE_Connected)
            {
                docroot.login(username.text, password.text)
            }
            else if(Connection.serverUrl !== "")
            {
                Connection.reconnectServer()
            }
        }
        icon: Icons.lock

    }

    Item
    {
        height: 5
        width: parent.width
    }

    Connections
    {
        target: Connection
        onStateChanged:
        {
            if(Connection.state == Connection.STATE_Connected)
            {
                if(username.text !== "" && password.text !== "")
                {
                    docroot.login(username.text, password.text)
                    return;
                }
            }
        }
    }

    Column
    {
        width: parent.width
        spacing: 15
        ViewActionButton
        {
            height: 10
            hasBorder: false
            text: qsTr("Passwort vergessen?")
            onClicked: docroot.resetPasswordClicked()
            fontSize: Fonts.verySmallControlFontSize
            anchors.left: parent.left
            anchors.leftMargin: -10
            opacity: .5
            Behavior on opacity { NumberAnimation{}}
        }
        StandardButton
        {
            width: parent.width
            text: "Login"
            onClicked:
            {
                if(Connection.state == Connection.STATE_Connected)
                {
                    docroot.login(username.text, password.text)
                }
                else if(Connection.serverUrl !== "")
                {
                    Connection.reconnectServer()
                }
            }
        }
    }

    SequentialAnimation
    {
        id: shakeAnimation
        NumberAnimation
        {
            target: password
            property: "x"
            to: -5
            duration: 60
        }

        NumberAnimation
        {
            target: password
            property: "x"
            to: 5
            duration: 60
        }

        NumberAnimation
        {
            target: password
            property: "x"
            to: -5
            duration: 60
        }
        NumberAnimation
        {
            target: password
            property: "x"
            to: 5
            duration: 60
        }

        NumberAnimation
        {
            target: password
            property: "x"
            to: 0
            duration: 60
        }
    }
}

