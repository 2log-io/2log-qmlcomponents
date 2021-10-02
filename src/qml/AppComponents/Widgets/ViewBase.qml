import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import UIControls 1.0

Item
{
    id: docroot
    property bool flip: docroot.width > docroot.height || viewActionContainer.children.length ===  0 // ( label.width + viewActionContainer.width + 55 ) < layout.width
    property string viewID
    default property alias content: contentContainer.children
    property alias header: header.children
    property StackView stackView: StackView.view
    property int index: StackView.index
    property string headline
    property int spacing: 20
    property alias viewActions: viewActionContainer.children
    property var canBack: function doBack(){return true}
    property alias actionContainer: actionWrapper2
    property int padding: (root.width > 500 ? 80 : 10)

    function goBack()
    {
       stackView.pop()
    }

    Item
    {
        id: layout
        width: docroot.width > 1480 ? 1400 : docroot.width - docroot.padding
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins:  docroot.width > 900 ? 20 : 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter

        ColumnLayout
        {
            anchors.fill: parent
            spacing: 0

            RowLayout
            {
                id: header
                visible: docroot.headline !== "" || header.children.length > 2
                Layout.minimumHeight: 60
                Layout.maximumHeight: 60
                Layout.fillWidth: true
                Item
                {
                    id: backButton
                    width: 40
                    visible:docroot.index > 0
                    enabled: visible
                    Icon
                    {

                        id: icon
                        width: 40
                        height: 40
                        anchors.centerIn: parent
                        icon:  Icons.leftArrow
                        anchors.verticalCenterOffset:  0
                        iconColor: Colors.lightGrey
                        MouseArea
                        {
                            hoverEnabled: true
                            anchors.fill: parent
                            anchors.rightMargin:  -label.contentWidth
                            id: area
                            onClicked:
                            {
                                if(docroot.canBack())
                                    stackView.pop()
                            }
                        }

                        states:
                        [
                        State
                        {
                            name:"hover"
                            when: area.containsMouse

                            PropertyChanges
                            {
                                target: icon
                                iconColor: Colors.white
                            }
                        }]

                        transitions: [
                            Transition {
                                from: "hover"
                                ColorAnimation {
                                    duration: 200
                                }

                            }
                        ]
                    }
                }

                Item
                {
                    Layout.fillWidth: true
                    height: parent.height
                    visible: docroot.headline !== ""
                    TextLabel
                    {
                        id: label
                        x: root.width < 500 && !backButton.visible  ? 20 : 0
                        fontSize: Fonts.headerFontSze
                        text: docroot.headline
                        anchors.verticalCenter: parent.verticalCenter
                        font.styleName: "Medium"
                    }

                }

                Item
                {
                    id: actionWrapper1
                    Layout.minimumHeight: 60
                    Layout.maximumHeight: 60
                    width: viewActionContainer.width
                }
            }

            Row
            {
                id: viewActionContainer

                height: parent.height
                spacing: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: docroot.flip  ? 0 : -10
                anchors.right: parent.right
                parent:
                {
                    return docroot.flip ? actionWrapper1 : actionWrapper2
                }

            }
            Item
            {
                id: actionWrapper2

                property alias offset: viewActionContainer.anchors.verticalCenterOffset
                Layout.minimumHeight: 40
                Layout.maximumHeight: 40
                width: parent.width
                height: 40
                Layout.fillWidth: true
                visible: !docroot.flip
            }


            Item
            {
                id: contentContainer
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }
    }
}
