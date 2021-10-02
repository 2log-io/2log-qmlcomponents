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
            text: qsTr("Einrichtung neuer Devices")
            width: parent.width
            horizontalAlignment:Text.AlignHCenter
            fontSize: Fonts.headerFontSze
            wrapMode: Text.Wrap
        }

        TextLabel
        {
            width: parent.width
            horizontalAlignment:Text.AlignHCenter
            text: qsTr("Für die Einrichtung neuer Devices benötigst du ein Android oder iOS Mobilgerät. Installiere dazu die 2log App aus dem PlayStore oder dem AppStore und folge den Anweisungen.")
            wrapMode: Text.Wrap
        }
    }

    StandardButton
    {
        transparent: true
        icon: Icons.leftArrow
        anchors.bottom: parent.bottom
        opacity: parent.active ? 1 : 0
        text: qsTr("Verstanden")
        onClicked: docroot.cancel()

        Behavior on opacity
        {
            NumberAnimation{ }
        }
    }
}
