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


import QtQuick 2.0
import QtQuick.Controls 2.12
import UIControls 1.0

Flickable
{
    id: docroot
    clip: true

    contentHeight: flickContent.height
    contentWidth: width


    property var billData

    Column
    {
        id: flickContent
        width: parent.width
        spacing: 20

        Repeater
        {
            model:docroot.billData.bills
            width: parent.width

            Column
            {
                id: billColumn
                width: parent.width
                Item
                {
                    height: 40
                    width: parent.width

                    TextLabel
                    {
                        anchors.left: parent.left
                        fontSize: Fonts.headerFontSze
                        anchors.margins: 20
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.accountingCode
                    }

                    Rectangle
                    {
                        anchors.right: parent.right
                        anchors.left: parent.left
                        anchors.rightMargin:  20
                        anchors.leftMargin: 20
                        anchors.bottom: parent.bottom
                        color: Colors.white_op50
                        height: 1
                    }
                }
                Repeater
                {
                    model: modelData.items
                    BillItemDelegate
                   {
                       name: modelData.name
                       price: modelData.price
                       flat: modelData.flat

                   }
                }

                Rectangle
                {
                    visible: modelData.discountPercent > 0
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.margins: 20
                    height: 1
                    color: Colors.white_op50
                }

                BillItemDelegate
                {
                    name: "Summe"
                    visible: modelData.discountPercent > 0
                    price: modelData.totalBrutto
                }

                BillItemDelegate
                {
                    visible: modelData.discountPercent > 0
                    name: modelData.discountPercent + "% Rabatt"
                    price: -1 * (modelData.totalBrutto -  modelData.totalNetto)
                }

                Rectangle
                {
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.margins: 20
                    height: 1
                    color: Colors.white_op50
                }

                Item
                {
                    height: 2
                    width: parent.width
                }

                Rectangle
                {
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.margins: 20
                    height: 1
                    color: Colors.white_op50
                }

                BillItemDelegate
                {
                    price: modelData.totalNetto
                }
            }
        }
    }
}

