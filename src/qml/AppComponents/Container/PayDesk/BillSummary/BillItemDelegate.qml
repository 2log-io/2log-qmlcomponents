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


import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick 2.8
import UIControls 1.0
import AppComponents 1.0

Rectangle
{
    id: docroot

    property bool flat
    property int price
    property string name

    opacity: flat ? .6 : 1
    width: parent.width
    height: 40
    color:Colors.darkBlue

    RowLayout
    {
        width: parent.width-40
        x:20
        height: parent.height

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            TextLabel
            {
                anchors.verticalCenter: parent.verticalCenter
                width: 200
                text: docroot.name
            }
        }

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Row
            {
                anchors.right: parent.right
                spacing: 4
                anchors.verticalCenter: parent.verticalCenter
                TextLabel
                {

                    horizontalAlignment: Qt.AlignRight
                    anchors.verticalCenter: parent.verticalCenter
                    text:(docroot.price / 100).toLocaleString(Qt.locale("de_DE"))

                    Rectangle
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.left: parent.left
                        height: 1
                        visible: docroot.flat
                    }
                }

                TextLabel
                {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "EUR"
                    fontSize: Fonts.verySmallControlFontSize
                    color: Colors.lightGrey
                }
            }
        }
    }
}
