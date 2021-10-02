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


import QtQuick 2.12
import QtQuick.Layouts 1.3
import UIControls 1.0
import QtQuick.Controls 2.0
import CloudAccess 1.0
import AppComponents 1.0

Container
{
    id: docroot

    width: 300
    headline:  qsTr("Willkommen!")

    StackView
    {
        id: stack
        width: parent.width
        height: 180
        initialItem: serverURL === "" ? connect : login
        clip: true



        pushEnter: Transition {
            id: pushEnter
            ParallelAnimation
            {

                XAnimator {  from: pushEnter.ViewTransition.item.width; to:0; duration: 400; easing.type: Easing.OutCubic }
                NumberAnimation { from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic ; properties: "opacity" }

            }
        }
        pushExit: Transition {
            id: pushExit
            ParallelAnimation
            {
                XAnimator { from: 0; to: -stack.currentItem.width; duration: 400;  easing.type: Easing.OutCubic}
                NumberAnimation { from: 1; to: 0; duration: 400; easing.type: Easing.OutCubic ; properties: "opacity" }
            }
        }


        popEnter: Transition {
            id: popEnter
            ParallelAnimation
            {
                XAnimator{from: -pushEnter.ViewTransition.item.width; to:0; duration: 400;easing.type: Easing.OutCubic}
                NumberAnimation { from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic ; properties: "opacity" }

            }
        }
        popExit: Transition {
            id: popExit
            ParallelAnimation {
                XAnimator{ from: 0; to: pushEnter.ViewTransition.item.width; duration: 400; easing.type: Easing.OutCubic }
               NumberAnimation { from: 1; to: 0; duration: 400; easing.type: Easing.OutCubic ; properties: "opacity" }

            }
        }


        Component
        {
            id: connect
            ConnectPage
            {
                id: page
                property string desc: "connect"

            }
        }


        Component
        {
            id: login
            LoginPage
            {                
                id: page
                property string desc: "login"
                onResetPasswordClicked: stack.push(resetPassw)
            }
        }

        Component
        {
            id: resetPassw

            ResetPasswordPage
            {
                id: page
                property string desc: "reset"
                onCancel: stack.pop()
            }
        }

        Timer
        {
            id: delayTimer
            interval: 250
            onTriggered:
            {

                if(QuickHub.state == QuickHub.STATE_Connected)
                {
                    if(stack.currentItem.desc !== "login")
                        stack.replace(login, StackView.PushTransition)
                }
                else if(QuickHub.state == QuickHub.STATE_Disconnected)
                {
                    if(serverURL === "")
                    {
                        if(stack.currentItem.desc !== "connect")
                            stack.replace(connect, StackView.PopTransition)
                    }
                    else
                    {
                        if(stack.currentItem.desc !== "login")
                            stack.replace(login, StackView.PushTransition)
                    }
                }
            }
        }

        Connections
        {
            target: QuickHub
            onStateChanged:
            {
                delayTimer.start()
            }
        }
    }
}
