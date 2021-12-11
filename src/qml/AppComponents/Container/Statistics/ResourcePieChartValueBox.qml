

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

BaseValueBox {
    id: docroot

    label: qsTr("Laufzeitverteilung")
    height: grid.height + 62

    property var model

    GridLayout {
        id: grid
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottomMargin: 20
        anchors.rightMargin: 20
        anchors.leftMargin: 20
        columnSpacing: 20
        rowSpacing: 20
        flow: docroot.width < 450 ? GridLayout.TopToBottom : GridLayout.LeftToRight

        Item {
            height: 200
            Layout.minimumHeight: 200
            Layout.maximumHeight: 200

            Layout.minimumWidth: grid.flow == GridLayout.TopToBottom ? 0 : 200
            Layout.maximumWidth: grid.flow == GridLayout.TopToBottom ? 10000 : 200

            Layout.fillWidth: true

            PieChart {
                id: piChart
                anchors.centerIn: parent
                width: 200
                height: width
                anchors.margins: 20
                model: docroot.model
                onItemHovered: if (index >= 0)
                                   list.currentIndex = index

                Column {
                    anchors.centerIn: parent

                    Row {
                        spacing: 10
                        TextLabel {
                            id: valueLabel
                            fontSize: Fonts.bigDisplayFontSize
                            text: {
                                var idx = piChart.hoveredIndex
                                if (idx >= 0)
                                    return ((piChart.model[idx].value
                                             / piChart.total) * 100).toFixed(1)
                                return ""
                            }
                        }

                        TextLabel {
                            visible: valueLabel.text !== ""
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 5
                            text: "%"
                            color: Colors.grey
                            opacity: .4
                            fontSize: Fonts.bigDisplayUnitFontSize
                        }
                    }
                }
            }
        }

        Item {
            Layout.minimumHeight: 200
            Layout.maximumHeight: 200

            height: 200
            Layout.fillWidth: true

            ListView {
                id: list
                clip: true
                anchors.fill: parent
                model: piChart.model

                delegate: Item {
                    height: 40
                    width: parent.width
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onContainsMouseChanged: {
                            if (containsMouse)
                                piChart.hoveredIndex = index
                            else
                                piChart.hoveredIndex = -1
                        }
                    }

                    RowLayout {
                        id: row
                        anchors.fill: parent
                        TextLabel {
                            Layout.alignment: Qt.AlignVCenter
                            Layout.fillWidth: true
                            color: index
                                   == piChart.hoveredIndex ? Colors.highlightBlue : Colors.white
                            Behavior on color {
                                ColorAnimation {}
                            }
                            text: {
                                var model = deviceModel.getDeviceModel(
                                            modelData._id.resourceID)
                                if (!model)
                                    return (index + 1) + ". " + modelData._id.resourceID

                                var txt = model.displayName
                                return (index + 1) + ". " + txt
                            }
                        }

                        Item {
                            width: 10
                            height: 10
                            Layout.minimumWidth: 10
                            Layout.maximumWidth: 10
                        }
                        TextLabel {
                            color: index
                                   == piChart.hoveredIndex ? Colors.highlightBlue : Colors.white
                            Behavior on color {
                                ColorAnimation {}
                            }
                            visible: row.width > 190
                            Layout.alignment: Qt.AlignVCenter
                            text: {
                                var time = HelperFunctions.formatMillis(
                                            modelData.value)
                                var txt = ""
                                if (time.hours > 0)
                                    txt += time.hours + "h "
                                txt += time.minutes + "m"
                                return txt
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Colors.white
                        opacity: .2
                        anchors.bottom: parent.bottom
                    }
                }
            }
        }
    }

    Column {
        anchors.centerIn: parent
        visible: list.count == 0
        spacing: 5
        TextLabel {
            text: qsTr("Keine Daten")
            anchors.horizontalCenter: parent.horizontalCenter
            fontSize: Fonts.bigDisplayFontSize
            opacity: .2
        }

        TextLabel {
            text: qsTr("im ausgewählten Zeitfenster")
            anchors.horizontalCenter: parent.horizontalCenter
            fontSize: Fonts.headerFontSze
            opacity: .2
        }
    }
}
