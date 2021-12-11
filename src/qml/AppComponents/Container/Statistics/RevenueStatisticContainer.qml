

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

Container {
    id: docroot
    headline: " "
    width: parent.width
    property alias statisticModel: model

    header: Item {
        anchors.fill: parent
        id: headerBox

        Row {
            anchors.right: parent.right
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20

            ContainerButton {
                id: setupbtn2
                anchors.verticalCenter: parent.verticalCenter
                icon: Icons.calendar
                onClicked: presetFlyout.open()

                OptionChooser {
                    id: presetFlyout
                    parent: setupbtn2
                    borderColor: Colors.greyBlue
                    options: [qsTr("Heute"), qsTr("Gestern"), qsTr(
                            "Diese Woche"), qsTr("Diesen Monat"), qsTr(
                            "4 Wochen")]
                    onSelectedIndexChanged: {
                        settingsModel.setProperty("preset", selectedIndex)

                        if (selectedIndex < 0)
                            return

                        setupbtn2.text = presetFlyout.options[presetFlyout.selectedIndex]
                        presetFlyout.close()
                        var result
                        switch (presetFlyout.selectedIndex) {
                        case 0:
                            result = cppHelper.today()
                            break
                        case 1:
                            result = cppHelper.yesterday()
                            break
                        case 2:
                            result = cppHelper.thisWeek()
                            break
                        case 3:
                            result = cppHelper.thisMonth()
                            break
                        case 4:
                            result = cppHelper.lastMonth()
                            break
                        }

                        modelwrapper.reload(result.from, result.to)
                    }

                    chooserWidth: 160
                }
            }
        }
    }

    property int range: 1 * 12 * 60 * 60 * 1000
    property date to: {
        var date = new Date()
        var date2 = new Date()
        date.setDate(date2.getDate() - 25)
        return date
    }

    property date from: {
        var date = new Date()
        date.setTime(to.getTime() - 2 * range)
        return date
    }

    Item {
        id: modelwrapper

        SynchronizedObjectModel {
            id: settingsModel
            resource: "home/settings/statistics"
            onInitializedChanged: {
                if (!initialized)
                    return

                var from = settingsModel.from
                var to = settingsModel.to
                var preset = settingsModel.preset
                if (preset === undefined) {
                    preset = 0
                }

                presetFlyout.selectedIndex = preset

                if (preset >= 0)
                    return

                setupbtn2.text = qsTr("Benutzerdefiniert")
                if (from !== undefined && (to === undefined || to === -1)) {
                    modelwrapper.reload(from, new Date())
                    return
                }

                if (from !== undefined && to !== undefined) {
                    modelwrapper.reload(from, to)
                    return
                }

                presetFlyout.selectedIndex = 0
            }
        }

        SynchronizedObjectModel {
            id: model
            resource: "statistics/metrics"
        }

        function reload(from, to) {
            labelRow.setText(from, to)

            if (to === -1)
                to = new Date()

            model.filter = {
                "from": from,
                "to": to
            }
            docroot.from = from
            docroot.to = to
        }
    }

    Column {
        width: parent.width
        spacing: 20

        Item {
            width: parent.width
            height: labelRow.height
            id: selectionLineWrapper
            visible: docroot.width <= 500
            CustomDateSelectionLine {
                id: labelRow
                width: parent.width
                parent: docroot.width > 500 ? headerBox : selectionLineWrapper
                mobile: docroot.width <= 500
                onToNowClicked: {
                    modelwrapper.reload(docroot.from, -1)
                    setupbtn2.text = qsTr("Benutzerdefiniert")
                    presetFlyout.selectedIndex = -1
                    settingsModel.setProperty("to", -1)
                }

                onFromChanged: {
                    modelwrapper.reload(from, docroot.to)
                    setupbtn2.text = qsTr("Benutzerdefiniert")
                    presetFlyout.selectedIndex = -1
                    settingsModel.setProperty("from", from)
                }

                onToChanged: {
                    modelwrapper.reload(docroot.from, to)
                    setupbtn2.text = qsTr("Benutzerdefiniert")
                    presetFlyout.selectedIndex = -1
                    settingsModel.setProperty("to", to)
                }
            }
        }
        Rectangle {
            width: parent.width

            height: 1
            color: Colors.white_op10
            visible: docroot.width <= 500
        }

        TextLabel {
            text: qsTr("Umsatz und Aktivität")
            opacity: .5
        }

        Flow {
            id: flow
            width: parent.width
            spacing: 20

            Flow {
                spacing: 20
                width: parent.width > 850 ? (parent.width - 20) / 2 : parent.width

                ValueBox {
                    label: qsTr("Aktive Nutzer")
                    width: parent.width > 400 ? (parent.width - 20) / 2 : parent.width
                    value: {
                        if (model.initialized
                                && model.userCount !== undefined) {
                            return model.userCount < 0 ? "0" : model.userCount
                        }

                        return ""
                    }
                }

                ValueBox {
                    width: parent.width > 400 ? (parent.width - 20) / 2 : parent.width
                    value: {
                        if (model.initialized) {
                            return model.totalUsage < 0 ? "0" : Math.round(
                                                              (model.totalUsage / (1000 * 60))
                                                              / model.userCount)
                        }
                        return ""
                    }

                    label: qsTr("Aktivität pro Nutzer (Ø)")
                    unit: "min"
                }

                ValueBox {
                    width: parent.width > 400 ? (parent.width - 20) / 2 : parent.width
                    value: {
                        if (model.initialized) {
                            return model.totalRevenue
                                    < 0 ? "0" : (model.totalRevenue / 100).toLocaleString(
                                              Qt.locale("de_DE"))
                        }
                        return ""
                    }

                    label: qsTr("Umsatz gesamt")
                    unit: "EUR"
                }
                ValueBox {
                    width: parent.width > 400 ? (parent.width - 20) / 2 : parent.width
                    value: {
                        if (model.initialized) {
                            var days = Math.round(
                                        Math.abs(
                                            docroot.from - docroot.to) / (1000 * 60 * 60 * 24))
                            return model.totalRevenue
                                    < 0 ? "0" : (model.totalRevenue / 100 / days).toLocaleString(
                                              Qt.locale("de_DE"))
                        }
                        return ""
                    }

                    label: qsTr("Tagesumsatz (Ø)")
                    unit: "EUR"
                }
            }

            Flow {
                spacing: 20
                width: parent.width > 850 ? (parent.width - 20) / 2 : parent.width
                ActiveUsersBarChartValueBox {
                    model: model.usersPerDay
                }
            }

            RevenueBarChartValueBox {
                model: model.revenueByDays
            }

            MachineRevenuePieChartValueBox {
                model: model.machineRevenue
            }
        }

        TextLabel {
            text: qsTr("Laufzeit und Wartung")
            opacity: .5
        }

        Flow {
            width: parent.width
            spacing: 20

            ResourcePieChartValueBox {
                model: model.machineRuntime
            }

            AverageMachineUsageValueBox {
                model: model.averageMachineUsage
            }
        }
    }
}
