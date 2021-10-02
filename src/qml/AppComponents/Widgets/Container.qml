import QtQuick 2.5
import QtQuick.Controls 2.5
import UIControls 1.0
import QtQuick.Layouts 1.1

ContainerBase
{
    id: docroot
    height: totalHeight
    property int totalHeight: column.height+ 1 * margins
    property alias header: headerSpace.children
    property alias contentHeight:contentWrapper.height
    property alias contentWidth:contentWrapper.width
    default property alias content: contentWrapper.children
    property string helpText
    property string headline    


    border.width: 2
    border.color: "transparent"

    function showError()
    {
        errorAnimation.start()
    }

    Item
    {
        id: content
        anchors.fill: parent

        SequentialAnimation
        {
            id: errorAnimation
            ColorAnimation {target: docroot; property:"border.color"; from: "transparent"; to: Colors.warnRed; duration: 50}
            PauseAnimation {duration: 200}
            ColorAnimation {target: docroot; property:"border.color"; to: "transparent"; from: Colors.warnRed; duration: 50}
            ColorAnimation {target: docroot; property:"border.color"; from: "transparent"; to: Colors.warnRed; duration: 50}
            PauseAnimation {duration: 200}
            ColorAnimation {target: docroot; property:"border.color"; to: "transparent"; from: Colors.warnRed; duration: 50}
        }

        Column
        {
            id: column
            width: parent.width
            y: -docroot.margins
            Item
            {
                id: header
                height: 40
                z: docroot.margins
                width: parent.width + 2 * docroot.margins
                x: -docroot.margins
                visible: headline !== ""

                Rectangle
                {
                    anchors.fill: parent;
                    color: Colors.greyBlue
                    radius: docroot.radius
                    Rectangle
                    {
                        color: parent.color
                        width: parent.width
                        height: 6
                        anchors.bottom: parent.bottom
                    }
                }


//                Shadow
//                {
//                     shadowTop: false
//                    shadowRight: false
//                     shadowLeft: false
//                    opacity: .1
//                }


                RowLayout
                {

                    anchors.fill: parent
                    anchors.rightMargin:  docroot.margins
                    anchors.leftMargin: docroot.margins
                    spacing: 0

                    TextLabel
                    {
                        id: headlineLabel
                        font.family: Fonts.simplonNorm_Medium
                        text:docroot.headline
                        color: Colors.white
                        fontSize: Fonts.subHeaderFontSize
                    }

                    HelpTextFlyout
                    {
                        height: 40
                        width: docroot.helpText == "" ? 0:30
                        flyoutWidth:header.width > 340 ? 300 : header.width -40
                        triangleDelta: headlineLabel.width + 12
                        helpText:docroot.helpText
                        flyoutParent: header
                        flyoutX: 15
                    }

                    Item
                    {
                        id: headerSpace
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                }
            }
            Item
            {
                height: docroot.margins
                width: parent.width
            }

            Column
            {
                id: contentWrapper
                width: parent.width
            }
        }
    }
}
