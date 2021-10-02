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
import AppComponents 1.0
import UIControls 1.0
import QtQuick.Layouts 1.3
import CloudAccess 1.0
import "../../Widgets"


Container
{
    id: docroot
    Layout.fillWidth: true
    Layout.minimumHeight: totalHeight
    Layout.maximumHeight: totalHeight
    //Layout.fillHeight: true
    headline:qsTr("Letzte Jobs")
    property string deviceID
    property int limit: 5
    property alias count: view.count

    ListView
    {
        id: view

        property int itemCount: count
        model: logModel
        height:  count <  docroot.limit ? count * 40 : docroot.limit * 40
        width: parent.width
        interactive: false
        clip: true
        delegate:
        BaseDelegate
        {
            id: delegate
            last: index == view.itemCount -1

            Item
            {
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout
                {
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    RoundGravatarImage
                    {
                        eMail: email
                        width: 30
                        height: 30
                        Layout.alignment: Qt.AlignVCenter
                     //   anchors.verticalCenter: parent.verticalCenter
                    }

                    Item
                    {
                        width: 10
                        height: parent.height
                    }

                    TextLabel
                    {
                      //  anchors.verticalCenter: parent.verticalCenter
                        text: userName
                        Layout.fillWidth: true
                        fontSize: Fonts.listDelegateSize
                    }

                    Row
                    {
                        id: duration
                        width: 100
                        visible: delegate.width > 520
                        height: parent.height
                        spacing:5

                        property int seconds: (TypeDef.parseISOLocal(endTime).getTime() - TypeDef.parseISOLocal(startTime).getTime()) / 1000

                        onSecondsChanged:
                        {
                            var hrs = parseInt(seconds / 3600)
                            var min = Math.round((seconds % 3600) / 60)
                            var s = Math.round(seconds % 60)

                            var text = ""
                            if(hrs > 0)
                            {
                                hrsLabel.text = hrs+"h"
                            }

                            if(min > 0)
                            {
                                minLabel.text = min+"m"
                            }



                                sLabel.text =("00" + s).slice(-2)+"s"

                        }
                        TextLabel
                        {
                            id: hrsLabel
                            width: 30
                           anchors.verticalCenter: parent.verticalCenter
                            fontSize: Fonts.listDelegateSize
                        }

                        TextLabel
                        {
                            id: minLabel
                            width: 30
                            anchors.verticalCenter: parent.verticalCenter
                            fontSize: Fonts.listDelegateSize
                            horizontalAlignment: Qt.AlignRight
                        }
                        TextLabel
                        {
                            id: sLabel
                            width: 30
                            anchors.verticalCenter: parent.verticalCenter
                            fontSize: Fonts.listDelegateSize
                        }
                    }

                    TextLabel
                    {
                        width: 100
                        horizontalAlignment: Text.AlignRight
                        text: (price / 100).toLocaleString(Qt.locale("de_DE"))
                        fontSize: Fonts.controlFontSize
                   //     anchors.verticalCenter: parent.verticalCenter
                        visible: delegate.width > 400
                    }
                    TextLabel
                    {
                        Layout.alignment: Qt.AlignVCenter
                        text: "EUR"
                        fontSize: Fonts.verySmallControlFontSize
                        color: Colors.lightGrey
                     //   anchors.verticalCenter: parent.verticalCenter

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

//            Row
//            {
//                id: jobInfo
//                Layout.alignment: Qt.AlignVCenter
//                spacing: 5

//            }
        }

        SynchronizedListModel
        {
            id: logModel
            property string userFilter
            property string resourceFilter
            preloadCount: 5
            resource: "labcontrol/logs"
            filter: {"match":{"resourceID":docroot.deviceID, "logType":0}, "limit": docroot.limit, "sort":{"timestamp": -1}}
        }
    }
}
