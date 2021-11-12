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
import CloudAccess 1.0
import AppComponents 1.0
import DeviceProvisioning 1.0

Popup
{
    id: docroot
    anchors.centerIn: Overlay.overlay
    width: root.width
    height: root.height
    modal: true
    focus: true

    signal provisioningFinished(string uuid)
    property string targetSSID
    property bool itsMe: false


    Connections
    {
        target: QuickHub
        function onStateChanged()
        {
            // when all is done
            if(docroot.itsMe && ProvisioningManager.state == ProvisioningManager.PROVISIONING_CONNECTED_TO_HOME_WIFI && QuickHub.state == QuickHub.STATE_Authenticated && root.provisioning)
            {
                if(ProvisioningManager.errorCode == ProvisioningManager.ERR_PROVISIONING_NO_ERROR)
                    docroot.provisioningFinished(ProvisioningManager.uuid)

                docroot.close()
                root.provisioning = false
                docroot.itsMe = false
            }
        }
    }

    Connections
    {
        target: ProvisioningManager
        function onStateChanged()
        {
           if(ProvisioningManager.state === ProvisioningManager.PROVISIONING_CONNECTED_TO_HOME_WIFI)
               timer.start()
        }
    }

    Timer
    {
        id: timer
        interval: 3000
        running:false
        repeat: false
        onTriggered:
        {
            QuickHub.disconnectServer()
            QuickHub.reconnectServer()
        }
    }

    onClosed:
    {
        stack.replace(stack.initialItem)
    }

    enter:
    Transition
    {
        PropertyAnimation
        {
            property: "opacity"
            from: .3
            to: 1
            duration: 500
            easing.type: Easing.OutCurve
        }

    }

    background: Item{}
    Overlay.modal:
    Rectangle
    {
        color: Colors.backgroundDarkBlue
    }


    Item
    {
        width: parent.width
        height: parent.height
        Stack
        {
            id: stack
            initialItem:
            {
                if(isMobile)
                    docroot.targetSSID.toLowerCase().includes("dot")  ? prepareDot : prepareSwitch
                else
                    useApp

            }
            anchors.fill: parent
        }
    }

    Component
    {
        id: useApp
        ProceedWithAppPage
        {
            onCancel: docroot.close()
        }
    }

    Component
    {
        id: prepareSwitch
        PrepareSwitchPage
        {
            onNext:
            {
                docroot.itsMe = true
                stack.push(password)
            }
            onCancel: docroot.close()
        }
    }

    Component
    {
        id: prepareDot
        PrepareDotPage
        {
            onNext:
            {
                docroot.itsMe = true
                stack.push(password)
            }
            onCancel: docroot.close()
        }
    }


    Component
    {
        id: password

        EnterWifiPasswordPage
        {
            onNext:
            {
                root.provisioning = true
                stack.push(provisioning)
                QuickHub.disconnectServer()
                ProvisioningManager.deviceSSID = docroot.targetSSID
                var server = QuickHub.serverUrl
                ProvisioningManager.startProvisioning(password, server, ssid)
            }
            onCancel: docroot.close()
        }
    }


    Component
    {
        id: provisioning
        ProvisioningPage
        {
            active: (StackView.status === StackView.Active)
            visible: StackView.status !== StackView.Inactive
            onCancel:ProvisioningManager.cancel()
        }
    }
}
