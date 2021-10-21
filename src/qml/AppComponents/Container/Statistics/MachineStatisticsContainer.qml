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
import CloudAccess 1.0
import QtQuick.Controls 2.0
import UIControls 1.0
import QtQuick.Layouts 1.3
import "../../Widgets"



Container
{
    id: docroot
    headline:qsTr("Nutzung")
    width: parent.width
    property string resourceID

    Item
    {
        SynchronizedObjectModel
        {
            id: model
            resource: "statistics/resource/" + resourceID
        }

        SynchronizedObjectModel
        {
            id: resetModel
            resource: "statistics/resource/" + resourceID
        }

        SynchronizedObjectModel
        {
            id: lastMaintainance
            resource: "public/maintainance/"+ resourceID +"/lastreset"
            onInitializedChanged:
            {
                if(initialized)
                {
                    var reset = lastMaintainance.reset
                    if(reset !== undefined)
                    {
                        var now = new Date()
                        var filter = {"from": reset, "to": now}

                        resetModel.filter = filter
                    }
                }
            }
        }
    }

    Flow
    {
        id: flow
        spacing: 20
        width: parent.width

        TimeValueBox
        {
            label: qsTr("Betriebsstunden")
            width: parent.width > 500 ? (parent.width - 40) / 3 : parent.width
            value:
            {
                if(model.initialized)
                {
                    return model.runtime
                }
                return -1
            }
        }

        TimeValueBox
        {
            id: counter
            label: qsTr("Betriebsstundenzähler")

          //  helpText: qsTr("Zählt die Betriebsstunden \über einen beliebigen Zeitraum.")

            width: parent.width > 500 ? (parent.width - 40) / 3 : parent.width

            value:
            {
                if(resetModel.initialized)
                {
                    return resetModel.runtime
                }
                return -1
            }

            TextLabel
            {
                y:27
                //anchors.right: parent.right
                anchors.left: parent.left
                anchors.margins: 10
                fontSize: 12
                opacity: .4
                text:  {
                    if(lastMaintainance.initialized && lastMaintainance.reset !== undefined)
                    {
                        return qsTr("Seit dem %1").arg(Qt.formatDate(lastMaintainance.reset, "dd.MM.yy"))
                    }
                    else
                        return ""
                }
            }
            IconButton
            {
                anchors.right: parent.right
                anchors.top:parent.top
                icon: Icons.refresh
                iconSize: 14
                iconColor: Colors.white_op50
                toolTipDelay: 1000
                toolTipText:
                {
                    qsTr("Zähler zurücksetzen")
                }

                onClicked:
                {
                    lastMaintainance.setProperty("reset", new Date())
                    resetModel.filter = {"from": new Date(), "to": new Date()}
                }
            }
        }

        ValueBox
        {
            width: parent.width > 500 ? (parent.width - 40) / 3 : parent.width
            value:
            {
                if(model.initialized)
                {
                    return model.revenue >= 0 ? (model.revenue / 100).toLocaleString(Qt.locale("de_DE")) : 0
                }
                return ""
            }

            label: qsTr("Umsatz")
            unit:"EUR"
        }
    }
}
