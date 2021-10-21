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
import CloudAccess 1.0
import AppComponents 1.0

import "../../Widgets"
import "../Statistics"

Container
{
    id: docroot
    headline:" "
    width: parent.width

    property date to:
    {
        var date = new Date()
        var date2 = new Date()
        date.setDate(date2.getDate()-25)
        return date
    }

    property int range: 1 * 12 * 60 * 60 * 1000

    property date from:
    {
        var date = new Date()
        date.setTime(to.getTime() - 2*range )
        return date
    }


    header:
    Item
    {
        SynchronizedObjectModel
        {
            id:settingsModel
            resource: "home/settings/payment"

            onInitializedChanged:
            {
                if(!initialized)
                    return;

                var from = settingsModel.from
                var to = settingsModel.to
                var preset = settingsModel.preset
                if(preset === undefined)
                {
                    preset = 0
                }

                presetFlyout.selectedIndex = preset

                if(preset >= 0)
                    return

                setupbtn2.text = qsTr("Benutzerdefiniert")
                if(from !== undefined && (to === undefined || to === -1))
                {
                    modelwrapper.reload(from, new Date())
                    return;
                }

                if(from !== undefined && to !== undefined)
                {
                    modelwrapper.reload(from, to)
                    return
                }

                presetFlyout.selectedIndex = 0;
            }
        }
        anchors.fill: parent
        id: headerBox

        Row
        {
            anchors.right: parent.right
            height: parent.height
            anchors.verticalCenter:parent.verticalCenter
            spacing: 20


            ContainerButton
            {
                id: setupbtn2
                anchors.verticalCenter:parent.verticalCenter
                icon: Icons.calendar
                onClicked: presetFlyout.open()

                OptionChooser
                {
                    id: presetFlyout
                    parent: setupbtn2
                    borderColor: Colors.greyBlue
                    options: [qsTr("Heute"),qsTr("Gestern"),qsTr("Diese Woche"), qsTr("Diesen Monat"), qsTr("4 Wochen")]
                    onSelectedIndexChanged:
                    {

                        settingsModel.setProperty("preset", selectedIndex)

                        if(selectedIndex < 0)
                            return

                        setupbtn2.text = presetFlyout.options[presetFlyout.selectedIndex]
                        presetFlyout.close()
                        var result
                        switch(presetFlyout.selectedIndex)
                        {
                            case 0: result = cppHelper.today(); break;
                            case 1: result = cppHelper.yesterday(); break;
                            case 2: result = cppHelper.thisWeek(); break
                            case 3: result = cppHelper.thisMonth(); break
                            case 4: result = cppHelper.lastMonth(); break
                        }

                        modelwrapper.reload(result.from, result.to)

                    }

                    chooserWidth: 160
                }
            }
        }
    }


    Item
    {
        ServiceModel
        {
            id: paymentService
            service: "payment"
        }

        id: modelwrapper
        function reload(from, to)
        {
            labelRow.setText(from,to)
            docroot.from = from
            docroot.to = to
            paymentService.call("getsales",{"from":from, "to":to},callback)
        }

        function callback(foo)
        {
            saleslist.model = foo
        }
    }


    ColumnLayout
    {
        width: parent.width
        height: docroot.height
        spacing: 20

        Item
        {
            height: labelRow.height
            Layout.minimumHeight: labelRow.height
            Layout.maximumHeight:  labelRow.height
            Layout.fillWidth: true
            id: selectionLineWrapper
            visible: docroot.width <= 500
            CustomDateSelectionLine
            {
                id: labelRow
                width: parent.width
                parent: docroot.width > 500 ? headerBox : selectionLineWrapper
                mobile:  docroot.width <= 500
                onToNowClicked:
                {
                    modelwrapper.reload(docroot.from, -1)
                    setupbtn2.text = qsTr("Benutzerdefiniert")
                    presetFlyout.selectedIndex = -1
                    settingsModel.setProperty("to", -1)
                }

                onFromChanged:
                {
                    modelwrapper.reload(from, docroot.to)
                    setupbtn2.text = qsTr("Benutzerdefiniert")
                    presetFlyout.selectedIndex = -1
                    settingsModel.setProperty("from", from)
                }

                onToChanged:
                {
                    modelwrapper.reload(docroot.from, to)
                    setupbtn2.text = qsTr("Benutzerdefiniert")
                    presetFlyout.selectedIndex = -1
                    settingsModel.setProperty("to", to)
                }
            }
        }

        ListView
        {
            id: saleslist
            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate:
            Item
            {
                height: 40
                width: parent.width-20
                x:10

                RowLayout
                {
                    anchors.fill: parent

                    Item
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        TextLabel
                        {
                            text: modelData.name
                            font.pixelSize: Fonts.listDelegateSize
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            elide: Text.ElideRight
                        }
                    }

                    Item
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        visible: docroot.width > 560
                        TextLabel
                        {
                            width: parent.width-40
                            text: modelData.count + " / " + modelData.flatCount
                            font.pixelSize: Fonts.listDelegateSize
                            anchors.verticalCenter: parent.verticalCenter
                            opacity: .5
                        }
                    }

                    Item
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        visible: docroot.width > 560
                        Row
                        {
                            spacing: 5
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            TextLabel
                            {
                                id: balanceLabel
                                horizontalAlignment: Qt.AlignRight
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: Fonts.listDelegateSize
                                text: (modelData.totalBruttoSaleAmount / 100).toLocaleString(Qt.locale("de_DE"))
                                width: 50
                            }
                            TextLabel
                            {
                                text: "EUR"
                                font.pixelSize: Fonts.verySmallControlFontSize
                                color: Colors.grey
                                opacity: .4
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: 1
                            }
                        }
                    }


                    Item
                    {
                        width: 120
                        Layout.fillHeight: true
                        Row
                        {
                            spacing: 5
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            TextLabel
                            {
                                id: balanceLabel2
                                horizontalAlignment: Qt.AlignRight
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: Fonts.listDelegateSize
                                text: (modelData.totalNettoSaleAmount / 100).toLocaleString(Qt.locale("de_DE"))
                                width: 50
                            }
                            TextLabel
                            {
                                text: "EUR"
                                font.pixelSize: Fonts.verySmallControlFontSize
                                color: Colors.grey
                                opacity: .4
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: 1
                            }
                        }
                    }
                    Item
                    {
                        width: 40
                        Layout.fillHeight: true
                        Icon
                        {
                            id: icon
                            opacity: 0
                            iconSize: 14
                            anchors.centerIn: parent
                            icon: Icons.trash
                            iconColor: Colors.warnRed

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked: docroot.deleteItem(model.uuid, index)
                            }
                        }
                    }
                }
            }
        }
    }
}
