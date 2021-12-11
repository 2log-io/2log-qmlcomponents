import QtQuick 2.5
import QtQuick.Layouts 1.3
import UIControls 1.0

Item {

    id: docroot

    property int spacing: 10
    property alias text: input.text
    property string label: "Device ID"
    property string error

    width: column.width
    height: column.height

    signal returnPressed

    function forceActiveFocus() {
        input.forceActiveFocus()
    }

    function showError(error) {
        docroot.error = error
        showErrorAnimation.start()
    }

    TextInput {
        id: input
        opacity: 0
        visible: false
        inputMask: "NNNN"
        onAccepted: docroot.returnPressed()
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -25

        inputMethodHints: Qt.ImhNoPredictiveText
    }

    MouseArea {
        anchors.fill: column
        onClicked: input.forceActiveFocus()
    }

    SequentialAnimation {
        id: showErrorAnimation

        NumberAnimation {
            from: 1
            to: 0
            target: errorRow
            property: "opacity"
            duration: 100
        }

        ScriptAction {
            script: {
                errorIcon.visible = true
                labelField.text = docroot.error
                input.text = ""
                input.cursorPosition = 0
            }
        }

        NumberAnimation {
            from: 0
            to: 1
            target: errorRow
            property: "opacity"
            duration: 100
        }
    }

    Column {
        id: column
        spacing: 10

        Row {
            id: errorRow
            spacing: 10
            Icon {
                id: errorIcon
                visible: false
                iconSize: 14
                icon: Icons.warning
                iconColor: Colors.warnRed
                anchors.verticalCenter: parent.verticalCenter
            }
            TextLabel {
                id: labelField
                text: docroot.label
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        RowLayout {
            height: 50
            width: 180
            spacing: docroot.spacing

            Repeater {
                model: 4
                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Rectangle {
                        id: background
                        radius: 5
                        anchors.fill: parent
                        color: Colors.black_op25
                        opacity: 1
                        border.width: 1
                        border.color: "transparent"

                        Rectangle {
                            id: cursor
                            width: parent.width - 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 4
                            height: 2
                            color: Colors.white
                            visible: {
                                if (!isMobile)
                                    input.cursorPosition == index
                                            && input.activeFocus
                                else
                                    index === input.preeditText.length
                                            && input.activeFocus
                            }
                            opacity: 0

                            SequentialAnimation {
                                loops: Animation.Infinite
                                id: blinkAnimation
                                running: cursor.visible
                                alwaysRunToEnd: true

                                PropertyAnimation {
                                    target: cursor
                                    property: "opacity"
                                    to: 1
                                    duration: 20
                                }

                                PauseAnimation {
                                    duration: 800
                                }
                                PropertyAnimation {
                                    target: cursor
                                    property: "opacity"
                                    duration: 20
                                    to: 0
                                }

                                PauseAnimation {
                                    duration: 800
                                }
                            }
                        }
                    }

                    TextLabel {
                        anchors.centerIn: parent
                        font.family: Fonts.simplonMono
                        fontSize: Fonts.bigDisplayFontSize
                        text: input.displayText.charAt(index).toUpperCase()
                        anchors.verticalCenterOffset: 2
                    }

                    states: [
                        State {
                            name: "focus"
                            when: input.activeFocus
                            PropertyChanges {
                                target: background
                                border.color: Colors.highlightBlue
                            }
                        }
                    ]

                    transitions: [
                        Transition {
                            ColorAnimation {
                                target: background
                                property: "border.color"
                            }
                        }
                    ]
                }
            }
        }
    }
}
