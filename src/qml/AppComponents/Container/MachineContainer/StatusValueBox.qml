

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
import "../Statistics"

BaseValueBox {
    id: docroot

    height: 120
    label: qsTr("Hardware")

    property int dotState: -10
    property int switchState: -10

    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 30
        anchors.margins: 20
        spacing: 10

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            visible: dotState > -10

            Image {
                id: dotImage
                anchors.centerIn: parent
                height: 50
                source: "qrc:/dot_line_svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true

                Item {
                    width: parent.paintedWidth
                    height: parent.paintedHeight
                    anchors.centerIn: parent
                    states: [
                        State {
                            name: "na"
                            when: docroot.dotState == -1

                            PropertyChanges {
                                target: infoBubbleDot
                                icon: Icons.question
                                infoColor: Colors.white
                            }
                        },

                        State {
                            name: "off"
                            when: docroot.dotState == -2

                            PropertyChanges {
                                target: infoBubbleDot
                                icon: Icons.offline
                                infoColor: Colors.warnRed
                            }
                        }
                    ]
                    InfoBubble {
                        id: infoBubbleDot
                        size: 20
                        x: parent.width * 0.8
                        y: 38
                        iconSize: 10
                    }
                }
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Image {
                id: switchImage
                anchors.centerIn: parent
                height: 70
                source: "qrc:/switch_line_svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true

                Item {
                    width: parent.paintedWidth
                    height: parent.paintedHeight
                    anchors.centerIn: parent

                    states: [
                        State {
                            name: "na"
                            when: docroot.switchState == -1

                            PropertyChanges {
                                target: infoBubbleSwitch
                                icon: Icons.question
                                infoColor: Colors.white
                            }
                        },

                        State {
                            name: "off"
                            when: docroot.switchState == -2

                            PropertyChanges {
                                target: infoBubbleSwitch
                                icon: Icons.offline
                                infoColor: Colors.warnRed
                            }
                        }
                    ]
                    InfoBubble {
                        id: infoBubbleSwitch
                        size: 20
                        x: parent.width * 0.6
                        y: 48
                        iconSize: 10
                    }
                }
            }
        }
    }
}
