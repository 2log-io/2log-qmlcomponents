

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
import AppComponents 1.0

TabContainer {
    id: docroot

    property string userID
    property int limit: 5

    LastTransferPage {
        width: docroot.width - 40
        height: docroot.height
        userID: docroot.userID
        limit: docroot.limit
        property string text: qsTr("Letzte Buchungen")
    }

    LastJobPage {
        width: docroot.width - 40
        height: docroot.height
        userID: docroot.userID
        limit: docroot.limit
        property string text: qsTr("Letzte Rechnungen")
    }
}
