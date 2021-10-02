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
import QtQuick.Controls 2.3
import UIControls 1.0

Item
{
    id: docroot

    signal next()

    Column
    {
        anchors.centerIn: parent
        spacing: 10

        TextLabel
        {
            text:qsTr("Verbinde deine Cobot Instanz mit 2log!")
        }

        Image
        {
            source: "qrc:/Assets/Cobot.svg"
            sourceSize.height: 50
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

//    StandardButton
//    {
//        id: confirmButton
//        transparent: true
//        icon: Icons.rightAngle
//        visible: opacity > 0
//        anchors.bottom: parent.bottom
//        anchors.right: parent.right
//        iconAlignment: Qt.AlignRight
//        text: qsTr("Weiter")
//        onClicked: docroot.next()

//        Behavior on opacity
//        {
//            NumberAnimation{ }
//        }
//    }
}