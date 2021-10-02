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
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import CloudAccess 1.0
import AppComponents 1.0
import "../../Dialogs/DeviceProvisioningDialog"

Container
{
    id: docroot

    property string deviceMapping
    property string mappingPrefix
    property string shortID
    property string helpText

    signal hooked(string mapping)

    Item
    {
        id: p
        property string mapping
        property alias deviceModel: deviceModel

        DeviceModel
        {
            id:deviceModel
            resource: docroot.deviceMapping
        }
    }

    function callback(data)
    {
        console.log(JSON.stringify(data))
        if(data.errorcode >= 0 )
        {
            stack.replace(dotOverview,StackView.PushTransition);
            docroot.hooked(p.mapping)
        }
        else
        {
            var errorMsg = qsTr("Unbekannter Fehler")
            switch(data.errorcode)
            {
                case -4: stack.push(alreadyInUse); return;
                case -10: errorMsg = qsTr("Unbekannte Controller-ID"); break;
                case -11: errorMsg = qsTr("Kein Gerät gefunden"); break;
                case -12: errorMsg = qsTr("Falscher Gerätetyp"); break;
            }
            stack.currentItem.showError(errorMsg)
        }
    }

    headline:qsTr("Administrations-Dot")
    helpText: docroot.helpText
    states:
    [
        State
        {
            name: "na"
            when: !deviceModel.available

            PropertyChanges
            {
                target: infoBubble
                icon: Icons.question
                iconColor: Colors.white
            }
        },
        State
        {
            name: "off"
            when: !deviceModel.deviceOnline

            PropertyChanges
            {
                target: infoBubble
                icon: Icons.offline
                iconColor: Colors.warnRed
            }
        }
    ]


    header:ContainerButton
    {
        id: setupbtn
        anchors.right: parent.right
        anchors.verticalCenter:parent.verticalCenter
        icon: Icons.swap
        enabled: stack.currentItem.stackID === "info" && deviceModel.available
        text: qsTr("Tauschen")

        onClicked:
        {
            stack.push(setup)
        }
    }

    RowLayout
    {
        width: parent.width
        spacing: docroot.spacing

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width / 3
            height: 150

            Icon
            {
                id: infoBubble
                iconSize: 100
                icon: Icons.check
                anchors.centerIn: parent
            }

        }

        StackView
        {
            id: stack
            initialItem: dotOverview
            Layout.fillWidth: true
            Layout.fillHeight: true
            height: 170

            clip: true

            Component
            {
                id: setup
                ChangeDevicePage
                {
                    property string stackID: "setup"
                    onBack: stack.pop()

                    onConfirm:
                    {
                        p.mapping = docroot.mappingPrefix+"/"+shortID
                        docroot.shortID = shortID
                        var data = {"mapping": p.mapping, "shortID":shortID, "force":false}
                        deviceService.call("hookWithShortID", data, docroot.callback )
                    }

                    ServiceModel
                    {
                        id: deviceService
                        service: "devices"
                    }
                }
            }

//            Component
//            {
//                id: isAlreadyHooked
//                IsAlreadyHookedPage
//                {
//                    onBack: stack.pop()
//                    property string stackID: "isAlreadyHooked"
//                    onYes: stack.push(setup)
//                    onNo:
//                    {
//                        provisioningPopup.open()
//                    }
//                }
//            }

//            DeviceProvisioningPopup
//            {
//                id: provisioningPopup
//                targetSSID: "I'm a Dot"

//                function prepareCallback(data)
//                {
//                    if(data.errCode >= 0)
//                    {
//                        stack.replace(dotOverview,StackView.PushTransition);
//                        settingsModel.selectedReader = p.mapping
//                    }
//                }

//                onProvisioningFinished:
//                {
//                    p.mapping = "servideDot/"+uuid;
//                    deviceService.call("prepareMappingWithUUID", {"mapping": p.mapping, "uuid":uuid} , provisioningPopup.prepareCallback )
//                }
//            }

            Component
            {
                id: alreadyInUse
                AlreadeInUsePage
                {
                    onBack: stack.pop()
                    property string stackID: "alreadyInUse"
                    onConfirm: deviceService.call("hookWithShortID", {"mapping": p.mapping, "shortID": docroot.shortID, "force":true}, docroot.callback )

                    ServiceModel
                    {
                        id: deviceService
                        service: "devices"
                    }
                }
            }


            Component
            {
                id: dotOverview

                StackLayout
                {
                    id: stacklayout
                    property string stackID: "info"
                    currentIndex: deviceModel.available ?  0 : 1
                    Item
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column
                        {
                            anchors.centerIn: parent
                            spacing: 10

                            DeviceInfoPage
                            {
                                deviceModel:p.deviceModel
                            }
                        }
                    }

                    Item
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column
                        {
                            anchors.right: parent.right
                            anchors.left:parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.margins: 30
                            width: parent.width
                            spacing: docroot.spacing

                            TextLabel
                            {
                                width: parent.width
                                text: qsTr("Aktuell ist kein Device zugewiesen.")
                                wrapMode: Text.Wrap

                                Layout.fillWidth: true
                                font.styleName: "Medium"
                                fontSize: Fonts.subHeaderFontSize
                            }
                        }

                        StandardButton
                        {
                            text:qsTr("Jetzt einrichten")
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            transparent:true
                            icon: Icons.rightAngle
                            iconAlignment: Qt.AlignRight

                            onClicked:
                            {
                                stack.push(setup)
                            }
                        }
                    }
                }
            }
        }
    }
}

