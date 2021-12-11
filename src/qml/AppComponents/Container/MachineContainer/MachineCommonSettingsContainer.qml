

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
import AppComponents 1.0
import "../../Widgets"

Container {

    property alias unsavedChanges: form.edited
    function save() {
        if (form.checkValid()) {
            pageWrapper.save()
            return true
        }
        return false
    }

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

            if (suction.dirty) {
                if (suction.editedSelectedIndex === 0) {
                    model.suction = 0
                    return
                }

                model.suction = suctionModel.getModelAt(
                            suction.editedSelectedIndex - 1).deviceID
            }

            if (typeCombo.dirty) {
                model.tag = TypeDef.machineType[typeCombo.editedSelectedIndex].code
            }

            if (dependsOnSuction.dirty) {
                model.dependsOnSuction = dependsOnSuction.editedChecked
            }
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
            label: qsTr("Abschalten nach [min]")
            id: autoOff
            Binding on text {
                value: model ? model.idleTimeTimeout / 1000 / 60 : ""
            }
            validator: IntValidator {
                bottom: 0
                top: 60
            }
            mandatory: true
        }

        FormDropDownItem {
            label: qsTr("Typ")
            id: typeCombo

            //Binding on text {value: model.tag}
            options: TypeDef.getLongStrings(TypeDef.machineType)
            selectedIndex: model ? TypeDef.getIndexOf(TypeDef.machineType,
                                                      model.tag) : 0
        }

        FormDropDownItem {
            id: suction
            label: qsTr("Absauge")
            selectedIndex: {
                if (!model)
                    return 0

                var suction = model.suction
                if (suction === "")
                    return 0

                for (var i = 0; i < suctionModel.count; i++) {
                    if (suctionModel.getModelAt(i).deviceID === suction)
                        return i + 1
                }

                return 0
            }

            options: {
                var options = []
                options.push(qsTr("Keine Absauge"))
                for (var i = 0; i < suctionModel.count; i++) {
                    var description = suctionModel.getModelAt(i).displayName
                    if (description === "")
                        description = dotModel.getModelAt(i).deviceID
                    options.push(description)
                }
                return options
            }
        }

        FormCheckItem {
            id: dependsOnSuction
            label: qsTr("Absauge muss laufen")
            checked: model
                     && model.dependsOnSuction !== undefined ? model.dependsOnSuction : false
        }
    }

    Item {
        FilteredDeviceModel {
            id: suctionModel
            deviceType: ["Suction"]
        }
    }
}
