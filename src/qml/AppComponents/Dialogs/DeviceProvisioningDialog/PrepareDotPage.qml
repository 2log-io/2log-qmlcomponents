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
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.4
import UIControls 1.0
import AppComponents 1.0


Item
{
    id: docroot

    property bool active: (StackView.status === StackView.Active)
    signal next()
    signal cancel()

    visible: StackView.status !== StackView.Inactive

    Column
    {
        anchors.centerIn: parent
        width: parent.width - 80
        spacing: 50

        TextLabel
        {
            text: qsTr("Versetze den Dot nun in den Pairing Modus")
            width: parent.width
            horizontalAlignment:Text.AlignHCenter
            fontSize: Fonts.headerFontSze
            wrapMode: Text.Wrap
        }

        Image
        {
            id: image
            width: parent.width  - 40
            anchors.horizontalCenter: parent.horizontalCenter

            source: "qrc:/dot_line_svg"
            fillMode: Image.PreserveAspectFit
        }

        TextLabel
        {
            width: parent.width
            horizontalAlignment:Text.AlignHCenter
            text: qsTr("Drücke und halte den Reset Knopf auf der Rückseite mit einem spitzen Gegenstand bis der LED-Kreis ganz geschlossen ist.\n\nSobald der Dot blau leuchtet ist er bereit zum Koppeln.")
            wrapMode: Text.Wrap
        }
    }

    StandardButton
    {
        transparent: true
        icon: Icons.cancel
        anchors.bottom: parent.bottom
        opacity: parent.active ? 1 : 0
        text: qsTr("Abbrechen")
        onClicked: docroot.cancel()

        Behavior on opacity
        {
            NumberAnimation{ }
        }
    }

    StandardButton
    {
        transparent: true
        icon: Icons.rightAngle
        text: qsTr("Weiter")
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        opacity: parent.active ? 1 : 0
        iconAlignment:Qt.AlignRight
        onClicked: docroot.next()

        Behavior on opacity
        {
            NumberAnimation{ }
        }
    }
}
