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


import QtQuick 2.8
import UIControls 1.0
import QtQuick.Layouts 1.3
import AppComponents 1.0
import CloudAccess 1.0


Container
{
    id: docroot
    width: parent.width
    headline: qsTr("Passwort zurücksetzen")
    signal passwordChanged(bool success,string code)

    RowLayout
    {
        width: parent.width

        spacing: 20

        TextField
        {
            id: originPass
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            placeholderText:qsTr("Altes Passwort")
            nextOnTab: pass1.field
            field.echoMode: TextInput.Password
        }


        TextField
        {
            id: pass1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            placeholderText: qsTr("Neues Passwort")
            nextOnTab: pass2.field
            field.echoMode: TextInput.Password
        }

        TextField
        {
            id: pass2
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            placeholderText: qsTr("Neues Passwort wiederholen")
            field.echoMode: TextInput.Password
        }


        StandardButton
        {
            enabled: (pass1.text === pass2.text) && (originPass.text !== "") && (pass1.text !== "")
            text:qsTr("Passwort ändern")
            onClicked: UserLogin.changePassword(originPass.text, pass2.text, parent.changePassCb)
        }

        function changePassCb(success, code)
        {
            docroot.passwordChanged(success, code)
            originPass.text = ""
            pass1.text = ""
            pass2.text = ""
        }
    }
}
