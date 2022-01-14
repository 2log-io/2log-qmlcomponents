

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
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import UIControls 1.0
import AppComponents 1.0

Flow {
    id: docroot

    signal fromChanged(date from)
    signal toChanged(date to)
    signal toNowClicked
    property bool mobile: isMobile

    anchors.verticalCenter: parent.verticalCenter
    x: -3

    function setText(from, to) {
        fromDatePicker.selectedDate = from
        toDatePicker.selectedDate = (to === -1 ? new Date() : to)
        var todayFrom = Qt.formatDateTime(from,
                                          "dd.MM.yyyy") == Qt.formatDateTime(
                    new Date(), "dd.MM.yyyy")

        if (todayFrom) {
            headlineA.text = qsTr("Von ")
            headlineB.text = "<a href=\"fromDate\">" + qsTr("heute") + "</a>"
        } else {
            headlineA.text = qsTr("Vom ")
            headlineB.text = "<a href=\"fromDate\">" + Qt.formatDateTime(
                        from, "dd.MM.") + "</a>"
        }
        // headlineD.text = "<a href=\"fromTime\">" + Qt.formatDateTime(from, "hh:mm") +"</a>"
        headlineD.text = Qt.formatDateTime(from, "hh:mm") + " "

        if (to === -1) {

            headlineF.text = "<a href=\"toDate\">" + qsTr("jetzt") + "</a>"
            headlineE2.visible = false
            headlineG.visible = false
            headlineH.visible = false
            headlineI.visible = false
            return
        }

        headlineE2.visible = true
        headlineG.visible = true
        headlineH.visible = true
        headlineI.visible = true

        var todayTo = Qt.formatDateTime(to, "dd.MM.yyyy") == Qt.formatDateTime(
                    new Date(), "dd.MM.yyyy")
        if (todayTo) {
            headlineF.text = "<a href=\"toDate\">" + qsTr("heute") + "</a> "
            headlineE2.visible = false
        } else {
            headlineF.text = "<a href=\"toDate\">" + Qt.formatDateTime(
                        to, "dd.MM.") + "</a> " //++"  bis jetzt"
            headlineE2.visible = true
        }
        // headlineH.text = "<a href=\"toTime\">"+Qt.formatDateTime(to, "hh:mm")+"</a>"
        headlineH.text = Qt.formatDateTime(to, "hh:mm") + " "
    }

    TextLabel {
        id: headlineA
        anchors.verticalCenterOffset: 2
        fontSize: Fonts.subHeaderFontSize
        text: qsTr("Vom ")
    }

    TextLabel {
        id: headlineB
        anchors.verticalCenterOffset: 2
        fontSize: Fonts.subHeaderFontSize
        linkColor: Colors.white_op50
        onLinkActivated: {
            if (link == "fromDate") {
                dateFlyoutFrom.open()
            }
        }

        FlyoutBox {
            id: dateFlyoutFrom
            parent: headlineB
            anchors.centerIn: mobile ? Overlay.overlay : undefined
            triangleHeight: mobile ? 0 : 12
            dim: mobile
            modal: mobile

            Overlay.modal: Rectangle {
                color: Colors.black_op50
            }

            Item {
                width: 250
                height: 250
                //                CalendarWidget {
                //                    id: fromDatePicker
                //                    anchors.fill: parent
                //                    maximumDate: toDatePicker.selectedDate
                //                    onClicked: {
                //                        date.setHours(0)
                //                        docroot.fromChanged(date)
                //                    }
                //                }
            }
        }
    }

    TextLabel {
        id: headlineC
        anchors.verticalCenterOffset: 2
        fontSize: Fonts.subHeaderFontSize
        text: " um "
    }

    TextLabel {
        id: headlineD
        anchors.verticalCenterOffset: 2
        fontSize: Fonts.subHeaderFontSize
        linkColor: Colors.white_op50
        onLinkActivated: {
            if (link == "fromTime") {
                timeFlyoutFrom.open()
            }
        }

        FlyoutBox {
            id: timeFlyoutFrom
            parent: headlineD
            width: 250
            height: 250

            Loader {
                active: timeFlyoutFrom.opened
                width: 250
                height: 250
            }
        }
    }

    TextLabel {
        id: headlineE
        anchors.verticalCenterOffset: 2
        fontSize: Fonts.subHeaderFontSize
        text: qsTr("Uhr bis ")
    }

    TextLabel {
        id: headlineE2
        anchors.verticalCenterOffset: 2
        fontSize: Fonts.subHeaderFontSize
        text: qsTr("zum ")
    }

    TextLabel {
        id: headlineF
        anchors.verticalCenterOffset: 2
        fontSize: Fonts.subHeaderFontSize
        linkColor: Colors.white_op50
        onLinkActivated: {
            if (link == "toDate") {
                dateFlyoutTo.open()
            }
        }

        FlyoutBox {
            id: dateFlyoutTo

            anchors.centerIn: mobile ? Overlay.overlay : undefined
            triangleHeight: mobile ? 0 : 12
            dim: mobile
            modal: mobile

            Overlay.modal: Rectangle {
                color: Colors.black_op50
            }

            Column {
                spacing: 10
                StandardButton {
                    width: 250
                    text: qsTr("Jetzt")
                    onClicked: docroot.toNowClicked()
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Colors.greyBlue
                }

                Item {
                    width: 250
                    height: 250

                    //                    CalendarWidget {
                    //                        id: toDatePicker
                    //                        anchors.fill: parent
                    //                        selectedDate: docroot.expires
                    //                        minimumDate: fromDatePicker.selectedDate
                    //                        onClicked: {
                    //                            date.setHours(23)
                    //                            date.setMinutes(59)
                    //                            docroot.toChanged(date)
                    //                        }
                    //                    }
                }
            }
        }
    }

    TextLabel {
        id: headlineG
        anchors.verticalCenterOffset: 2
        fontSize: Fonts.subHeaderFontSize
        text: " um "
    }

    TextLabel {
        id: headlineH
        anchors.verticalCenterOffset: 2
        fontSize: Fonts.subHeaderFontSize
        linkColor: Colors.white_op50
        onLinkActivated: {
            if (link == "toTime") {
                timeFlyoutTo.open()
            }
        }

        FlyoutBox {
            id: timeFlyoutTo
            parent: headlineD

            anchors.centerIn: mobile ? Overlay.overlay : undefined
            triangleHeight: mobile ? 0 : 12
            dim: mobile
            modal: mobile

            Overlay.modal: Rectangle {
                color: Colors.black_op50
            }

            Loader {
                active: timeFlyoutFrom.opened
                width: 250
                height: 250
            }
        }
    }

    TextLabel {
        id: headlineI
        anchors.verticalCenterOffset: 2
        fontSize: Fonts.subHeaderFontSize
        text: "Uhr"
    }
}
