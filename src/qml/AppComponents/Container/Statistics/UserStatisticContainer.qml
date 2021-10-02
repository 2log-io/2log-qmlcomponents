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

Container
{
    id: docroot
    headline:qsTr("Benutzer und Guthaben")
    width: parent.width

    property SynchronizedObjectModel model

   Flow
   {
       id: flow
       spacing: 20
       width: parent.width// > 850 ? (parent.width - 20) / 2 : parent.width

//       ValueBox
//       {
//           label: qsTr("Aktive Nutzer")
//           width: parent.width > 400 ? (parent.width - 20) / 2 : parent.width
//           value:
//           {
//               if(model.initialized)
//               {
//                   return model.userCount < 0 ? "0" : model.userCount
//               }

//               return ""
//           }
//       }

//       ValueBox
//       {
//           width: parent.width > 400 ? (parent.width - 20) / 2 : parent.width
//            value:
//            {
//                if(model.initialized)
//                {
//                    return model.totalRevenue < 0 ? "0" :  (model.totalRevenue / 100).toLocaleString(Qt.locale("de_DE"))
//                }
//                return ""
//            }

//            label: qsTr("Umsatz gesamt")
//            unit:"EUR"
//       }


//       ValueBox
//       {
//           width: parent.width > 400 ? (parent.width - 20) / 2 : parent.width
//            value:
//            {
//                if(model.initialized)
//                {
//                    var days =  Math.round(Math.abs(docroot.from - docroot.to) / (1000 * 60 * 60 * 24 ));
//                    return model.totalRevenue < 0 ? "0" :  (model.totalRevenue / 100 / days).toLocaleString(Qt.locale("de_DE"))
//                }
//                return ""
//            }

//            label: qsTr("Tagesumsatz (Ø)")
//            unit:"EUR"
//       }

       ValueBox
       {
           width: parent.width > 400 ? (parent.width - 20) / 2 : parent.width
            value:
            {
                if(model.initialized)
                {
                    return model.openCredit  >= 0 ? (model.openCredit / 100).toLocaleString(Qt.locale("de_DE")) : 0
                }
                return ""
            }

            label: qsTr("Guthaben (∑)")
            unit:"EUR"
       }

       ValueBox
       {
           width: parent.width > 400 ? (parent.width - 20) / 2 : parent.width
            value:
            {
                if(model.initialized)
                {
                    return model.debts >= 0 ? (model.debts / 100).toLocaleString(Qt.locale("de_DE")) : 0
                }
                return ""
            }

            label: qsTr("Kredit (∑)")
            unit:"EUR"
       }
   }

}
