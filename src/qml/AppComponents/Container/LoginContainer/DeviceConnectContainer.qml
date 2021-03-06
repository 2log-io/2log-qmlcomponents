

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

Container {
    id: docroot
    visible: Connection.state == Connection.STATE_Disconnected
    width: 300
    headline: qsTr("Willkommen!")
    property bool enableServerTextField: true

    ConnectPage {
        id: stack
        width: parent.width
        height: 220
        clip: true
        serverEnabled: docroot.enableServerTextField
        property string desc: "connect"
    }
}
