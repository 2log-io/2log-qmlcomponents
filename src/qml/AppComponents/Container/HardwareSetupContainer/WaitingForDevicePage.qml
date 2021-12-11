

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

Item {
    id: docroot

    property bool active: (StackView.status == StackView.Active)
    signal timeOut
    property int timeoutInterval: 20000

    width: parent ? parent.width : 0

    Column {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 20
        width: parent.width
        spacing: 40

        LoadingIndicator {
            height: 80
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TextLabel {
            text: qsTr("Warte auf neues Device...")
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Timer {
        interval: docroot.timeoutInterval
        onTriggered: {
            docroot.timeOut()
        }
        running: docroot.active
    }
}
