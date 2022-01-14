


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
import QtQuick
import QtQuick 2.12
import CloudAccess 1.0
import QtQuick.Controls 2.3
import UIControls 1.0

Item {
    id: docroot
    property bool active: (StackView.status == StackView.Active)
    signal cancel
    signal confirm(string spaceID, string spaceURL)

    Form {
        id: form
        width: parent.width - 20
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -20

        FormTextItem {
            label: qsTr("Space Name")
            id: nameField
            mandatory: true
            onEditedTextChanged: {
                urlField.text = "https://" + editedText.toLowerCase(
                            ) + ".cobot.me"
            }
        }

        FormTextItem {
            label: qsTr("Space URL")
            id: urlField
            mandatory: true
            validator: RegularExpressionValidator {
                regularExpression: /[https:\/\/]?(.+)\.cobot\.me/
            }
        }
    }

    StandardButton {
        transparent: true
        icon: Icons.leftAngle
        text: qsTr("Abbrechen")
        anchors.bottom: parent.bottom
        onClicked: docroot.cancel()
        opacity: docroot.active ? 1 : 0

        Behavior on opacity {
            NumberAnimation {}
        }
    }

    StandardButton {
        id: confirmButton

        transparent: true
        icon: Icons.check
        iconColor: Colors.highlightBlue
        opacity: docroot.active ? 1 : 0
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: "Los gehts!"
        onClicked: {

            var data = {
                "spaceURL": urlField.editedText,
                "spaceName": nameField.editedText
            }
            cobotService.call("connectWithOAuth", data, connectWithOAuthCb)
        }

        Behavior on opacity {
            NumberAnimation {}
        }
    }

    ServiceModel {
        id: cobotService
        service: "cobotservice"
    }

    function connectWithOAuthCb(data) {
        cppHelper.openUrl(data)
    }
}
