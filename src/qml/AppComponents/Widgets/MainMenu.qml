import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import CloudAccess 1.0
import UIControls 1.0
import AppComponents 1.0


ColumnLayout
{

    id: docroot
    spacing: 0

    property StackView stackView
    signal clicked()

    HeaderButton
    {
        text:qsTr("Benutzer")
        Layout.fillWidth: true
        width: parent.width
        height: 60
        icon: Icons.user
        selected: stackView.depth > 0 && stackView.currentItem !== null ?  stackView.currentItem.viewID === "users" : false
        onClicked:
        {
            stackView.replace(null, users)
            docroot.clicked()
        }
    }

    HeaderButton
    {
        Layout.fillWidth: true
        width: parent.width
        height:60
        text:qsTr("Ressourcen")
        icon: Icons.plug
        selected: stackView.depth > 0 && stackView.currentItem !== null ?  stackView.currentItem.viewID === "devices" : false
        onClicked:
        {
            stackView.replace(null, devices)
            docroot.clicked()
        }
    }

    HeaderButton
    {
        Layout.fillWidth: true
        width: parent.width
        height:60
        text:qsTr("Produkte")
        visible:  root.width > 1000
        icon: Icons.products
        selected: stackView.depth > 0 && stackView.currentItem !== null ?  stackView.currentItem.viewID === "products" : false
        onClicked:
        {
            stackView.replace(null, products)
            docroot.clicked()
        }
    }


    HeaderButton
    {
        Layout.fillWidth: true
        width: parent.width
        height:60
        text:qsTr("Kasse")
        visible:  root.width > 1000 &&  (QuickHub.currentUser.userData === undefined ? false : QuickHub.currentUser.userData.role !== "mngmt")
        icon: Icons.payDesk
        selected: stackView.depth > 0 && stackView.currentItem !== null ?  stackView.currentItem.viewID === "paydesk" : false
        onClicked:
        {
            stackView.replace(null, payDesk)
            docroot.clicked()
        }
    }

    HeaderButton
    {
        Layout.fillWidth: true
        width: parent.width
        height:60
        text:qsTr("Administration")
        visible:  root.width > 1000 &&  (QuickHub.currentUser.userData === undefined ? false : QuickHub.currentUser.userData.role !== "mngmt")
        icon: Icons.gear
        selected: stackView.depth > 0 && stackView.currentItem !== null ?  stackView.currentItem.viewID === "settings" : false
        onClicked:
        {
            stackView.replace(null, settings)
            docroot.clicked()
        }
    }


//    HeaderButton
//    {
//        text:qsTr("Auslastung")
//        width: parent.width
//        Layout.fillWidth: true
//        height: 60
//        visible: QuickHub.currentUser.userData === undefined ? false : QuickHub.currentUser.userData.role !== "mngmt"
//        icon:Icons.statistics
//        selected: stackView.depth > 0 && stackView.currentItem !== null ?  stackView.currentItem.viewID === "overview" : false
//        onClicked:
//        {
//            stackView.replace(null, overview)
//            docroot.clicked()
//        }
//    }

    HeaderButton
    {
        text:qsTr("Statistik")
        width: parent.width
        Layout.fillWidth: true
        height: 60
        icon: Icons.piechart
        selected: stackView.depth > 0 && stackView.currentItem !== null ?  stackView.currentItem.viewID === "statistics" : false
        onClicked:
        {
            stackView.replace(null, statistics)
            docroot.clicked()
        }
    }


    Item
    {
        Layout.fillHeight: true
        Layout.fillWidth: true
    }
}
