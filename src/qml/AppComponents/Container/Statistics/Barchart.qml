

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

Item {
    id: docroot

    property real stampWidth: width / ((repeater.count * 2) + 1)
    property alias model: repeater.model
    property alias max: repeater.max
    property bool showAxis: repeater.count > 0
    property string unit: ""
    property var valueFormat: function (value) {
        return value
    }

    Rectangle {
        width: 1
        height: row.height
        color: Colors.white_op50
        anchors.bottom: row.bottom
        visible: docroot.showAxis
    }

    Rectangle {
        x: 1
        height: 1
        width: parent.width - 1
        anchors.bottom: row.bottom
        color: Colors.white_op50
        visible: docroot.showAxis
    }

    Row {
        id: row
        anchors.fill: parent
        spacing: 0
        anchors.bottomMargin: 10

        Item {
            width: docroot.stampWidth / 2
            height: 100
        }

        Repeater {
            id: repeater

            property real max: {
                var max = 0
                for (var i = 0; i < count; i++) {
                    max = Math.max(max, model[i].value)
                }

                return max
            }

            function getHeight(value) {
                return (value / repeater.max) * row.height
            }

            Item {
                width: docroot.stampWidth * 2
                height: parent.height
                z: mouseArea.containsMouse ? 100000 : 0

                Rectangle {
                    FlyoutHelper {
                        id: flyout
                        opacity: mouseArea.containsMouse ? 1 : 0
                        triangleSide: Qt.BottomEdge
                        y: -height - 12
                        triangleDelta: (width / 2)
                        fillColor: Qt.darker(Colors.darkBlue, 1.2)
                        borderColor: Colors.greyBlue
                        borderWidth: 1

                        shadowOpacity: 0.1
                        shadowSizeVar: 8
                        width: flyoutLayout.width + 24
                        height: flyoutLayout.height + 24
                        anchors.horizontalCenter: parent.horizontalCenter

                        Column {
                            id: flyoutLayout
                            anchors.centerIn: parent
                            spacing: 10

                            Row {
                                spacing: 10
                                TextLabel {
                                    width: 50
                                    horizontalAlignment: Qt.AlignHCenter
                                    verticalAlignment: Qt.AlignVCenter
                                    text: docroot.valueFormat(modelData.value)
                                }
                            }
                        }
                    }

                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 1
                    width: docroot.stampWidth
                    height: repeater.getHeight(modelData.value)
                    color: mouseArea.containsMouse ? Colors.highlightBlue : Colors.white
                    Behavior on color {
                        ColorAnimation {}
                    }
                }

                TextLabel {
                    visible: mouseArea.containsMouse
                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 5
                    text: Qt.formatDate(cppHelper.toDate(modelData.ts),
                                        "dd.MM.yy")
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }
        }

        Item {
            width: docroot.stampWidth / 2
            height: 100
        }
    }
}
