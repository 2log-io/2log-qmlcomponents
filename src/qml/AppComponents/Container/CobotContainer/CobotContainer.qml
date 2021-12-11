

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

Container {
    id: contact
    headline: "Cobot"
    property bool available: stateInfo.CobotPluginAvailable !== undefined
                             && stateInfo.CobotPluginAvailable

    states: [
        State {
            when: stateInfo.ConnectionState === "NOT_CONNECTED"
            name: "notConnected"

            StateChangeScript {
                script: stack.replace(notConnected)
            }

            PropertyChanges {
                target: disconnectBtn
                visible: false
            }
            PropertyChanges {
                target: connectBtn
                visible: true
            }
        },
        State {
            when: stateInfo.ConnectionState === "INIT_CONNECTION"
            name: "connecting"
        },
        State {
            when: stateInfo.ConnectionState === "CONNECTED"
            name: "connected"
            StateChangeScript {
                script: stack.replace(connected)
            }

            PropertyChanges {
                target: disconnectBtn
                visible: true
            }
            PropertyChanges {
                target: connectBtn
                visible: false
            }
        }
    ]

    header: Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: contact.spacing

        ContainerButton {
            id: disconnectBtn
            anchors.verticalCenter: parent.verticalCenter
            icon: Icons.disconnect
            text: qsTr("Trennen")
            onClicked: stack.push(stepToDisconnect)
        }

        ContainerButton {
            id: connectBtn
            anchors.verticalCenter: parent.verticalCenter
            icon: Icons.link
            text: "Verbinden"
            onClicked: stack.push(two)
        }
    }

    StackView {
        id: stack
        clip: true
        width: parent.width
        height: 150
    }

    Item {
        Component {
            id: notConnected

            NotConnected {}
        }

        Component {
            id: connected

            Connected {
                onNext: stack.push(two)
                spaceURL: stateInfo.initialized ? stateInfo.SpaceURL : ""
            }
        }

        Component {
            id: two
            StepToConnect {
                onCancel: stack.pop()
            }
        }

        Component {
            id: stepToDisconnect
            StepToDisconnect {
                onConfirm: stack.pop()
                onCancel: stack.pop()
            }
        }

        SynchronizedObjectModel {
            id: stateInfo
            resource: "cobot/state"
        }
    }
}
