

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
import CloudAccess 1.0
import AppComponents 1.0
import "../../Widgets"

Container {
    id: contact
    headline: qsTr("Kontaktdaten")
    property SynchronizedObjectModel userModel

    property alias unsavedChanges: form.edited
    function save() {
        if (form.checkValid()) {
            pageWrapper.save()
            return true
        }
        return false
    }

    Item {
        id: pageWrapper

        function save() {
            if (form.edited) {
                if (nameLabel.dirty) {
                    userModel.name = nameLabel.editedText
                }

                if (mailLabel.dirty) {
                    userModel.mail = mailLabel.editedText
                }

                if (surnameLabel.dirty) {
                    userModel.surname = surnameLabel.editedText
                }

                if (roleCombo.dirty) {
                    userModel.role = TypeDef.roles[roleCombo.editedSelectedIndex].code
                }
            }
        }
    }

    header: ContainerButton {
        visible: form.edited
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        icon: Icons.save
        text: "Speichern"
        onClicked: {
            if (form.checkValid())
                pageWrapper.save()
        }
    }

    Form {
        id: form
        width: parent.width
        FormTextItem {
            label: qsTr("Vorname")
            id: nameLabel
            Binding on text {
                value: userModel.name
            }
            mandatory: true
        }

        FormTextItem {
            label: qsTr("Nachname")
            id: surnameLabel
            Binding on text {
                value: userModel.surname
            }
            mandatory: true
        }

        FormTextItem {
            label: qsTr("eMail")
            id: mailLabel
            Binding on text {
                value: userModel.mail
            }
            validator: RegExpValidator {
                regExp: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
            }
            mandatory: true
        }

        FormDropDownItem {
            id: roleCombo
            label: qsTr("Rolle")
            options: TypeDef.getLongStrings(TypeDef.roles)
            property string role
            Binding on role {
                value: userModel.role
            }
            selectedIndex: TypeDef.getIndexOf(TypeDef.roles, role)
            //            onEditedSelectedIndexChanged:
            //            {

            //                if(editedSelectedIndex > 0)
            //                {
            //                    courseCombo.enabled = false
            //                    courseCombo.selectedIndex = -1
            //                    courseCombo.editedSelectedIndex = -1
            //                    courseCombo.mandatory = false
            //                }
            //                else
            //                {
            //                   // courseCombo.dirty = true
            //                    courseCombo.mandatory = true
            //                    courseCombo.enabled = true

            //                    if(userModel.course != "")
            //                    {
            //                        courseCombo.selectedIndex = Qt.binding(function(){return TypeDef.getIndexOf(TypeDef.courses, userModel.course) })
            //                    }
            //                }
            //            }
        }

        //        FormDropDownItem
        //        {
        //            id: courseCombo
        //            label:qsTr("Studiengang");
        //            placeholder: qsTr("keine Auswahl")
        //            property string course
        //            Binding on course{value:userModel.course}
        //            options: TypeDef.getLongStrings(TypeDef.courses);
        //            selectedIndex:  TypeDef.getIndexOf(TypeDef.courses, course)
        //        }
    }

    Item {
        Rectangle {
            z: 10

            color: Colors.darkBlue
            width: form.width
            height: form.height
            opacity: !userModel.initialized ? 1 : 0
            LoadingIndicator {
                visible: parent.opacity != 0
            }
        }
    }
}
