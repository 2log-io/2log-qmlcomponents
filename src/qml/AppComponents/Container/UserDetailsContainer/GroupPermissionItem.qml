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
import QtQuick.Layouts 1.3
import AppComponents 1.0
import UIControls 1.0

BaseItem
{
    id: docroot
    height: 150
    width: 150

    property string icon: Icons.group
    signal          clicked()
    property int    permissionState: 0
    property date   expires
    property string deviceName
    signal          secondaryActionClicked()
    property bool   isTouch
    signal          dateSelected(date date)

    borderOpacity: .35

    MouseArea
    {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: docroot.clicked()
    }

    Row
    {
        id: buttonRow
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: -1
        anchors.bottom: parent.bottom
        anchors.margins: 10

        RadioGroupButton
        {
            id: radioLevel0
            alignment: Qt.AlignLeft
            iconChar: Icons.minus
            iconCheckedColor: Colors.white

            onClicked: if(permissionState == 1) docroot.clicked()
            toolTipText: permissionState == 1 ? qsTr("Gruppenberechtigung entziehen") : qsTr("Keine Berechtigung")
        }

        RadioGroupButton
        {
            id: radioLevel1
            alignment: Qt.AlignRight
            autoExclusive: true
            iconChar: Icons.group
            iconCheckedColor: Colors.highlightBlue
            onClicked: if(permissionState == 0) docroot.clicked()
            toolTipText: permissionState == 0 ? qsTr("Gruppenberechtigung erteilen") : qsTr("Gruppenberechtigung erteilt")
        }
    }

    Icon
    {
        id: icon
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        icon: Icons.group
        iconSize: 40
        opacity: .5
        iconColor: Colors.white
    }

    Item
    {
        height: 40
        width: parent.width
        anchors.top: parent.top
        anchors.margins: 10

        TextLabel
        {
            text:docroot.deviceName
            fontSize: Fonts.controlFontSize
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    TextLabel
    {
        id: expiresLabel

        property string dateString: Qt.formatDate(docroot.expires, "dd.MM.yy")
        anchors.bottom: buttonRow.top
        anchors.margins: 6
        opacity: dateString !== ""
        text:qsTr("bis %1").arg(dateString)
        fontSize: Fonts.smallControlFontSize
        color: Colors.grey
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle
        {
            id: dateRect
            anchors.fill: parent
            anchors.margins: -2
            anchors.rightMargin: -4
            anchors.leftMargin:  -4
            radius: 3
            opacity: dateMouseArea.containsMouse || dateFlyout.opened ? .1 : 0


            MouseArea
            {
                id: dateMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked:dateFlyout.open()
                enabled: expiresLabel.opacity === 1
            }

            FlyoutBox
            {
                id: dateFlyout
                parent: dateRect

                Loader
                {
                    active: dateFlyout.opened
                    width: 250
                    height: 250
                    sourceComponent:
                    CalendarWidget
                    {
                        anchors.fill:parent
                        selectedDate: docroot.expires
                        onClicked: docroot.dateSelected(date)
                   }
                }
            }
        }
    }


    onStateChanged: console.log(state)
    states:
    [
        State
        {
            name:"active"
            when: docroot.permissionState === 1

            PropertyChanges
            {
                target:radioLevel1
                checked: true
            }


            PropertyChanges
            {
                target:docroot
                borderColor:Colors.highlightBlue
            }
        },


        State
        {
            name:"none"
            when: docroot.permissionState === 0 && !docroot.hasGroupPermission

            PropertyChanges
            {
                target: expiresLabel
                opacity: 0
            }

            PropertyChanges
            {
                target: radioLevel0
                checked: true
            }

            PropertyChanges
            {
                target:docroot
                borderColor:Colors.warnRed
                backgroundOpacity: .0
            }

        }
    ]


//    ColumnLayout
//    {
//        anchors.fill: parent
//        anchors.margins: 10

//        Icon
//        {
//            id: icon
//            Layout.alignment:Qt.AlignCenter
//            icon: docroot.icon
//            iconSize: 40
//            iconColor: Colors.white
//            opacity: .5
//        }

//        Item
//        {
//            height: 40
//            Layout.fillWidth: true
//            Layout.alignment:Qt.AlignBottom

//            Column
//            {
//                width: parent.width
//                anchors.bottom: parent.bottom

//                TextLabel
//                {
//                    text:docroot.deviceName
//                    fontSize: Fonts.controlFontSize
//                    anchors.horizontalCenter: parent.horizontalCenter
//                }

//                TextLabel
//                {
//                    property string dateString: Qt.formatDate(docroot.expires, "dd.MM.yy")
//                    opacity: dateString !== ""
//                    id: expiresLabel
//                    text:"bis " +  dateString
//                    fontSize: Fonts.smallControlFontSize
//                    color: Colors.grey
//                    anchors.horizontalCenter: parent.horizontalCenter
//                }
//            }
//        }
//    }

//    MouseArea
//    {
//        id: mouse
//        anchors.fill: parent
//        hoverEnabled: true
//        onClicked: docroot.clicked()
//    }

//    states:
//    [
//        State
//        {
//            name:"active"
//            when: docroot.permissionState === 1

//            PropertyChanges
//            {
//                target: icon
//                opacity: 1
//                iconColor: Colors.highlightBlue
//            }

//            PropertyChanges
//            {
//                target: expiresLabel
//                opacity: 1
//            }
//        }
//    ]
}
