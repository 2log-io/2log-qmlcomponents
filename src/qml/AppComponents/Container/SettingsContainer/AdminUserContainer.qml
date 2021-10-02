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
import QtQuick.Controls 2.4
import UIControls 1.0
import QtQuick.Layouts 1.3
import AppComponents 1.0
import CloudAccess 1.0


Container
{
    id: docroot
    width: parent.width
    headline: qsTr("2log Administratoren")
    helpText: qsTr("Hier bestimmst du, wer sich in dieses 2log Portal einloggen darf. Je nach Rolle sind einzelne Funktionen eingeschränkt. Administrator und Mitarbeiter haben jeweils Zugriff auf alle Funktionen. Der einzige Unterschied besteht darin, dass Mitarbeiter keine Administratoren ernennen dürfen. Ein Nutzer mit der Rolle Sekretariat hat ausschließlich Zugriff auf die Benutzerverwaltung.")

    header:ContainerButton
    {
        anchors.right: parent.right
        anchors.verticalCenter:parent.verticalCenter
        icon: Icons.addUser
        text: qsTr("Administrator hinzufügen")
        onClicked:
        {
            nameField.forceActiveFocus()
        }
    }

    function dleleteUserallback(success, code)
    {
        if(code === QuickHub.PermissionDenied)
        {
            deleteUserStatus.text="Access Denied!";
        }

        if(code === QuickHub.IncorrectPassword)
        {
            deleteUserStatus.text="Wrong password!";
        }

        if(code === QuickHub.NoError)
        {
            deleteUserStatus.text="Success!";
            deleteUserId.text = ""
            deletePassword.text = ""
        }

        if(code === QuickHub.UserNotExists)
        {
            deleteUserStatus.text="Unknown User!";
        }
    }

    Column
    {
        width: parent.width

        RowLayout
        {
            width: parent.width -10
            spacing: 10
            x: 10
            height: 45

            Item
            {
                Layout.fillHeight: true
                Layout.fillWidth: true
                TextField
                {
                    id:nameField
                    placeholderText: qsTr("Name")
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                     nextOnTab: loginField.field
                     mandatory:true
                }
            }

            Item
            {
                Layout.fillHeight: true
                Layout.fillWidth: true
                TextField
                {
                    id: loginField
                    placeholderText: qsTr("LogIn")
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    nextOnTab: roleDropDown
                    mandatory:true
                }
            }

            Item
            {

                Layout.fillHeight: true
                width: 110
                Layout.minimumWidth: 110
                Layout.maximumWidth: 110

                DropDown
                {
                    id: roleDropDown
                    placeholderText: qsTr("Rolle")
                    options: TypeDef.getLongStrings(TypeDef.adminRoles)// ["Student","Angestellter","Extern"]
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    mandatory:true
                    nextOnTab: mailField.field
                }

            }
            Item
            {
                Layout.fillHeight: true
                Layout.fillWidth: true
                TextField
                {
                    id: mailField
                    mandatory:true
                    placeholderText: qsTr("eMail")
                    field.validator: RegExpValidator { regExp:/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                }
            }


            ServiceModel
            {
                id: labService
                service: "lab"
            }

            StandardButton
            {
                icon: Icons.addUser
                Layout.alignment: Qt.AlignRight
                onClicked:
                {
                    if(!checkInut())
                        return;

                    var user =
                    {
                        'userID': loginField.text,
                        'level':TypeDef.adminRoles[roleDropDown.selectedIndex].code,
                        'eMail':mailField.text,
                        'name': nameField.text
                    }

                    labService.call("addSystemUser", user, addUserCb)
                }

                function addUserCb(data)
                {
                    JSON.stringify(data)
                    var code = data.errrorcode
                    if( code === QuickHub.UserAlreadyExists)
                    {
                        addUserStatus.text="User already exists!";
                    }

                    if(code === QuickHub.PermissionDenied)
                    {
                        addUserStatus.text="Access Denied!";
                    }

                    if(code === QuickHub.NoError)
                    {
                        mailField.text = ""
                        loginField.text = ""
                        nameField.text = ""
                        roleDropDown.selectedIndex = -1
                        dummy.forceActiveFocus()
                    }
                }

                function checkInut()
                {

                    var nameOK = nameField.check()
                    var loginOK = loginField.check()
                    var roleOK = roleDropDown.check()
                    var mailOK = mailField.check()

                    if(!nameOK)
                    {
                        nameField.field.forceActiveFocus()
                        return false;
                    }

                    if(!loginOK)
                    {
                        loginField.field.forceActiveFocus()
                        return false;
                    }

                    if(!roleOK)
                    {
                        roleDropDown.forceActiveFocus()
                        return false;
                    }

                    if(!mailOK)
                    {
                        mailField.forceActiveFocus()
                        return false;
                    }

                    return true;
                }
            }
        }

        TextInput{id: dummy; visible: false}


        Item
        {
            height: 5
            width: parent.width
        }

        ListView
        {
            id: list
            property string selectedUser
            signal userClicked(string userID)
            interactive: false
            height: contentHeight

            opacity: nameField.field.activeFocus || mailField.field.activeFocus  || loginField.field.activeFocus || roleDropDown.activeFocus ? .2 : 1
            Behavior on opacity {NumberAnimation{duration: 200}}
            UserListModel
            {
                id: userModel
            }


            model: userModel
            width: parent.width
            delegate:

            Item
            {
                width: parent.width + 10
                height: 40

                MouseArea
                {
                    id: area
                    hoverEnabled: true
                    propagateComposedEvents: true
                    onClicked:
                    {
                        dummy.forceActiveFocus()
                        roleDropDown.selectedIndex = -1
                    }
                    anchors.fill: parent
                }

                Rectangle
                {
                    id: backGroundRect
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    color:"white"
                    opacity: 0
                }

                RowLayout
                {
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    anchors.leftMargin:  10
                    spacing: 10

                    Item
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        RowLayout
                        {
                           anchors.fill: parent
                           spacing: 10
                           property string eMailAddress: eMail

                           RoundGravatarImage
                           {
                               eMail: parent.eMailAddress
                               width: 30
                               height: 30
                               Layout.alignment:  Qt.AlignVCenter
                           }

                           TextLabel
                           {
                               Layout.fillWidth: true
                               text:  userName == "" ? userID : userName
                               font.pixelSize: 16
                               Layout.alignment:  Qt.AlignVCenter
                               color: Colors.white
                               width: parent.width
                               elide:Text.ElideRight
                               opacity: 1
                           }
                        }
                    }
                    Item
                    {

                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        TextLabel
                        {
                            text:userID
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                            color: Colors.white
                            width: parent.width
                            elide:Text.ElideRight
                            opacity: 1
                        }
                    }
                    Item
                    {

                        Layout.fillHeight: true
                        width: 110
                        Layout.minimumWidth:  110
                        Layout.maximumWidth: 110

                        DropDown
                        {
                            id: roleDelegateDropDown
                            placeholderText: "Rolle"
                            options: TypeDef.getLongStrings(TypeDef.adminRoles)// ["Student","Angestellter","Extern"]
                            selectedIndex: TypeDef.getIndexOf(TypeDef.adminRoles, userData.role)
                            width: parent.width
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 2
                            lineOnHover:true
                            enabled: QuickHub.currentUser.userID !== userID
                            onIndexClicked:
                            {
                                var level = TypeDef.adminRoles[index].code
                                console.log(level+ " "+index)
                                var data =
                                {
                                    'userID':userID,
                                    'level': level
                                }

                                labService.call("changeUserLevel", data, function(result){console.log(JSON.stringify(result))})
                            }

                        }
                    }

                    Item
                    {

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        TextLabel
                        {
                            text: eMail == "" ? "k.A." : eMail
                            font.pixelSize: 16
                            font.italic:  eMail == ""
                            anchors.verticalCenter: parent.verticalCenter
                            color: Colors.grey
                            opacity: eMail == "" ? .8 : 1
                            width: parent.width
                            elide:Text.ElideRight
                        }
                    }

                    Item
                    {

                        width: 35
                        height: 35

                        IconButton
                        {
                            id: iconButton
                            anchors.centerIn: parent
                            visible: false
                            icon: Icons.userDelete
                            iconColor: Colors.warnRed
                            iconSize:14
                            area.hoverEnabled: false
                            onClicked:
                            {
                                deleteUserDialog.userID = userID
                                deleteUserDialog.open()
                            }
                        }
                    }
                }

                states:
                [
                    State
                    {
                        name:"hover"
                        when: area.containsMouse || roleDelegateDropDown.containsMouse || roleDelegateDropDown.open
                        PropertyChanges
                        {
                            target:backGroundRect
                            opacity: .05
                        }

                        PropertyChanges
                        {
                            target:iconButton
                            visible:  QuickHub.currentUser.userID !== userID
                        }
                    }
                ]
            }
        }
        InfoDialog
        {
            id: deleteUserDialog
            property string userID
            anchors.centerIn: Overlay.overlay
            text: qsTr("Den Nutzer %1 wirklich löschen?").arg(userID)
            icon: Icons.userDelete
            iconColor: Colors.warnRed

            StandardButton
            {
                text:qsTr("Löschen")
                fontColor: Colors.warnRed
                onClicked:
                {
                    QuickHub.deleteUser(deleteUserDialog.userID)
                    deleteUserDialog.close()
                }
            }

            StandardButton
            {
                text:qsTr("Abbrechen")
                onClicked: deleteUserDialog.close()
            }
        }
    }

}
