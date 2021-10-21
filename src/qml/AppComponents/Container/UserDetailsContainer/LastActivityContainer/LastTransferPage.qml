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
import QtQuick.Layouts 1.3
import CloudAccess 1.0
import "../../../Widgets"


ListView
{
    id: docroot

    property int itemCount: count
    property int limit: 5
    property string userID

    model: logModel2
    height:  count <  docroot.limit ? count * 40 : docroot.limit * 40
    width: parent.width
    interactive: false
    clip: true

    delegate:
    BaseDelegate
    {
        last: index == docroot.itemCount -1
        id: delegate

        Item
        {
            id: delegateWrapper
            Layout.fillWidth: true
            Layout.fillHeight: true

            property bool bindingHelper: false

            RowLayout
            {
                anchors.verticalCenter: parent.verticalCenter
                anchors.fill: parent

                TextLabel
                {
                    visible: delegate.width > 600
                    Layout.fillWidth: visible
                    Layout.alignment: Qt.AlignVCenter
                    text:
                    {
                        description === "" ? "<i>Ohne Kommentar</i>": description
                    }

                    fontSize: Fonts.listDelegateSize
                }



                TextLabel
                {

                    Layout.minimumWidth: delegate.width <= 600 ? 0 : 100
                    Layout.maximumWidth:delegate.width > 600 ? 100 : 1000
                    Layout.fillWidth: delegate.width <= 600
                    Layout.alignment: Qt.AlignVCenter
                    text:executive
                    fontSize: Fonts.listDelegateSize

                }


                TextLabel
                {
                    width: 100
                    Layout.minimumWidth: 80
                    Layout.maximumWidth: 80

                    horizontalAlignment: Text.AlignRight
                    text: (price / 100).toLocaleString(Qt.locale("de_DE"))
                    fontSize: Fonts.listDelegateSize
              //      anchors.verticalCenter: parent.verticalCenter
                }

                TextLabel
                {
                    Layout.alignment: Qt.AlignVCenter
                    text: "EUR"
                    fontSize: Fonts.verySmallControlFontSize
                    color: Colors.lightGrey
//                        anchors.verticalCenter: parent.verticalCenter
                    visible: delegate.width > 400
                }
                Item
                {
                    id: content
                    width: 150
                    height: parent.height

                    TimeFormatter
                    {
                        id: formatter
                        time: timestamp
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }



    SynchronizedListModel
    {
        id: logModel2
        property string userFilter
        property string resourceFilter
        preloadCount: 5
        resource: "labcontrol/logs"
        filter: ({"match":{"userID":docroot.userID, "logType": 12}, "limit": docroot.limit, "sort":{"timestamp": -1}})
    }

    Rectangle
    {
        z: 10
        color: Colors.darkBlue
        anchors.fill: parent
        opacity: !logModel2.initialized? 1 : 0
        LoadingIndicator
        {
            visible: parent.opacity != 0
        }
    }
}
