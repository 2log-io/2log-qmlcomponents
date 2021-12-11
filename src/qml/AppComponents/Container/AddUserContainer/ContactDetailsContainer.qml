

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
import UIControls 1.0
import CloudAccess 1.0
import AppComponents 1.0
import "../../Widgets"

Container {
    id: contact
    headline: qsTr("Kontaktdaten")

    property string name: nameField.text
    property string surname: surnameField.text
    property string eMail: emailField.text
    property int role: roleDD.selectedIndex

    // property int course: studgDD.selectedIndex
    Column {
        width: parent.width

        TextField {
            id: nameField
            mandatory: true
            width: parent.width
            placeholderText: qsTr("Vorname")
            nextOnTab: surnameField.field
            Layout.fillWidth: true
        }

        TextField {
            id: surnameField
            mandatory: true
            width: parent.width
            placeholderText: qsTr("Nachname")
            nextOnTab: emailField.field
            Layout.fillWidth: true
        }

        TextField {
            id: emailField
            mandatory: true
            width: parent.width
            nextOnTab: roleDD
            placeholderText: qsTr("eMail")
            field.validator: RegExpValidator {
                regExp: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
            }
        }

        DropDown {
            id: roleDD
            mandatory: true
            width: parent.width
            options: TypeDef.getLongStrings(TypeDef.roles)
            placeholderText: qsTr("Rolle")
            onSelectedIndexChanged: if (selectedIndex >= 0)
                                        studgDD.selectedIndex = -1
        }
    }

    function checkInput() {
        var mailOK = emailField.acceptableInput
        var nameOK = nameField.acceptableInput
        var surnameOK = surnameField.acceptableInput
        var roleOK = roleDD.acceptableInput
        var studgOK = true // studgDD.acceptableInput
        return mailOK && nameOK && surnameOK && roleOK && studgOK
    }

    function validateInput() {
        var mailOK = emailField.check()
        var nameOK = nameField.check()
        var surnameOK = surnameField.check()
        var roleOK = roleDD.check()
        var studgOK = true //studgDD.check()

        if (!nameOK) {
            nameField.field.forceActiveFocus()
            return false
        }

        if (!surnameOK) {
            surnameField.field.forceActiveFocus()
            return false
        }

        if (!mailOK) {
            emailField.field.forceActiveFocus()
            return false
        }

        if (!roleOK) {
            roleDD.forceActiveFocus()
            return false
        }

        if (!studgOK) {
            studgDD.forceActiveFocus()
            return false
        }

        return true
    }

    function clear() {
        emailField.text = ""
        nameField.text = ""
        surnameField.text = ""
        roleDD.selectedIndex = -1
        //  studgDD.selectedIndex = -1
    }
}
