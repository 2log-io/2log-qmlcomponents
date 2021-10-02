import QtQuick 2.5
import UIControls 1.0
import QtQuick.Layouts 1.3


ViewBase
{
    id: docroot
    default property alias content: layout.children
    signal scrollAnimationFinished()
    property alias scrollVelocity: flickable.verticalVelocity
    objectName: "ScrollViewBase"
    //property alias screenOverlay: overlay.children

    Component.onCompleted:
    {
        actionContainer.parent = actionContainerWrapper
        actionContainer.offset = 0
        actionContainer.y = 0
    }
    Flickable
    {
        clip: true
        id: flickable
        maximumFlickVelocity: 1000
        boundsBehavior: Flickable.DragOverBounds
        anchors.fill: parent
        contentWidth: width
        contentHeight: layout.height + 100

        Column
        {
            id: layout
            width: parent.width

            Item
            {
                id: actionContainerWrapper
                height: docroot.actionContainer.visible ? 50 : 0
                width: parent.width
            }
        }

        NumberAnimation
        {
            id: scrollAnimation
            target: flickable
            property: "contentY"
            easing.type: Easing.OutQuad
            onRunningChanged: if(!running) docroot.scrollAnimationFinished()
        }
    }

    function scrollToTop()
    {
        scrollAnimation.to = 0;
        scrollAnimation.start()
    }


    function scrollToBottom()
    {
        scrollAnimation.to = flickable.contentHeight - flickable.height;
        scrollAnimation.start()
    }




    Rectangle
    {
        anchors.top: flickable.top
        height: 20
        width: parent.width
        opacity: .2
        visible: flickable.contentY > 0
        gradient:
        Gradient
        {
            GradientStop { position: 0.0; color: Colors.black }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }


//    Item
//    {
//        id: overlay
//        anchors.fill: parent
//    }
}
