

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
import QtQuick
import UIControls 1.0
import QtQuick.Layouts 1.1
import CloudAccess 1.0
import "../../Widgets"

Container {
    headline: qsTr("Pricing")

    function save() {
        if (form.checkValid()) {
            pageWrapper.save()
            return true
        }
        return false
    }

    property alias unsavedChanges: form.edited

    header: ContainerButton {
        visible: form.edited
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        icon: Icons.save
        text: qsTr("Speichern")
        onClicked: {
            if (form.checkValid())
                pageWrapper.save()
        }
    }

    Item {
        id: pageWrapper
        function save() {
            if (price.dirty)
                model.pricePerUnit = parseInt(price.editedText.replace(
                                                  ",", ".") * 100)

            if (interval.dirty)
                model.unitDuration = interval.editedText * 1000

            if (type.dirty)
                model.payMode = type.editedSelectedIndex

            if (minBalance.dirty)
                model.minimumBalance = parseInt(minBalance.editedText.replace(
                                                    ",", ".") * 100)

            if (employees.dirty)
                model.employeesForFree = employees.editedChecked
        }
    }

    property DeviceModel model
    Form {
        id: form
        width: parent.width
        FormDropDownItem {
            id: type
            label: qsTr("Abrechnung")
            selectedIndex: model
                           && model.payMode !== undefined ? model.payMode : -1
            options: [qsTr("Nach Nutzungdsdauer"), qsTr(
                    "Pauschale pro Job"), qsTr("Pauschale pro Session"), qsTr(
                    "Nach Session-Zeit")]
        }

        FormTextItem {
            label: qsTr("Preis [EUR]")
            id: price
            validator: RegularExpressionValidator {
                regularExpression: /^\d+([\.,]\d{2})?$/
            }
            Binding on text {
                value: model ? (model.pricePerUnit / 100).toLocaleString(
                                   Qt.locale("de_DE")) : ""
            }
            mandatory: true
        }
        FormTextItem {
            label: qsTr("Abrechnungsintervall [sec]")
            id: interval
            enabled: type.editedSelectedIndex === 0
                     || type.editedSelectedIndex === 3
            validator: IntValidator {
                bottom: 0
                top: 600
            }
            Binding on text {
                value: model ? model.unitDuration / 1000 : ""
            }
        }

        FormTextItem {
            label: qsTr("Mindestguthaben [EUR]")
            id: minBalance
            validator: RegularExpressionValidator {
                regularExpression: /^\d+([\.,]\d{2})?$/
            }
            Binding on text {
                value: model ? (model.minimumBalance / 100).toLocaleString(
                                   Qt.locale("de_DE")) : ""
            }
        }

        FormCheckItem {
            id: employees
            label: qsTr("für Mitarbeiter umsonst")
            checked: model ? model.employeesForFree : false
        }
    }
}
