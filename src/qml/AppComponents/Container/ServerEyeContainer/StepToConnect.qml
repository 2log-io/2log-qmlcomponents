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


import QtQuick 2.12
import CloudAccess 1.0
import QtQuick.Controls 2.3
import UIControls 1.0

Item
{
    id: docroot
    property bool active: (StackView.status == StackView.Active)
    signal cancel()
    signal waitForConnect()


    Form
    {
        id: form
        width: parent.width -20
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -30

        FormTextItem
        {
            label:qsTr("Customer ID")
            id: customerID
            mandatory: true
        }

        FormTextItem
        {
            label:qsTr("Secret Key")
            id: secretKey
            mandatory: true
        }

        FormTextItem
        {
            label:qsTr("External Customer Number")
            id: customerNumber
            mandatory: true
        }
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


    StandardButton
    {
        id: confirmButton
        icon: Icons.check
        opacity: docroot.active ? 1 : 0
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: "Verbinden"
        onClicked:
        {
            if(!form.checkValid())
                return

            var data = {"secret": secretKey.editedText, "customerID": customerID.editedText, "externalUser": customerNumber.editedText}
            serverEyeService.call("connect", data, connectCb)
        }

        Behavior on opacity
        {
            NumberAnimation{ }
        }
    }


    ServiceModel
    {
        id: serverEyeService
        service: "servereye"
    }

    function connectCb(data)
    {
        if(data.success)
        {
            docroot.waitForConnect()
        }
    }
}
