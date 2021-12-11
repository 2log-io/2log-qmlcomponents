

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
import QtQuick.Layouts 1.1
import CloudAccess 1.0
import "../../Widgets"

Container {
    id: docroot
    headline: qsTr("Allgemein")
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

    Item {
        id: pageWrapper
        function save() {
            if (name.dirty)
                model.getProperty("displayName").value = name.editedText

            if (autoOff.dirty)
                model.idleTimeTimeout = autoOff.editedText * 1000 * 60
        }
    }

    property DeviceModel model

    Form {
        id: form
        width: parent.width
        FormTextItem {
            label: qsTr("Anzeigename")
            id: name
            Binding on text {
                value: model ? model.getProperty("displayName").value : ""
            }
            mandatory: true
        }

        FormTextItem {
            label: qsTr("Typ")
            id: type
            enabled: type.editedSelectedIndex === 0
            Binding on text {
                value: model ? model.tag : ""
            }
        }
    }

    Item {
        height: 10
        width: parent.width
    }
}
