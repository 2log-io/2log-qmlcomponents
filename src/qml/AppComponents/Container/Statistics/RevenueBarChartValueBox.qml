

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
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.12
import UIControls 1.0

BaseValueBox {
    id: docroot

    label: qsTr("Umsatz pro Tag")

    property string value
    property string unit
    property alias model: bar.model

    Barchart {
        id: bar
        visible: !hint.visible
        anchors.fill: parent
        anchors.margins: 20
        anchors.topMargin: 40
        valueFormat: function (value) {
            return (value / 100).toLocaleString(Qt.locale("de_DE")) + "€"
        }
    }

    Column {
        id: hint
        anchors.centerIn: parent
        visible: model === undefined || model.length === 0 || bar.max === 0.0
        spacing: 5
        TextLabel {
            text: qsTr("Keine Daten")
            anchors.horizontalCenter: parent.horizontalCenter
            fontSize: Fonts.bigDisplayFontSize
            opacity: .2
        }

        TextLabel {
            text: qsTr("im ausgewählten Zeitfenster")
            anchors.horizontalCenter: parent.horizontalCenter
            fontSize: Fonts.headerFontSze
            opacity: .2
        }
    }
}
