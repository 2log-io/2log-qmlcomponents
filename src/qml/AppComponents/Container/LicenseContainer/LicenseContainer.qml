import QtQuick 2.8
import UIControls 1.0
import QtQuick.Layouts 1.3
import AppComponents 1.0
import CloudAccess 1.0

Container {
    id: docroot
    width: parent.width
    headline: qsTr("Über 2log.io")

    TextLabel {
        width: parent.width
        onLinkActivated: cppHelper.openUrl(link)
        wrapMode: Text.Wrap
        linkColor: Colors.white
        text: qsTr("<h2>2log.io ist freie Software! </h2><br><br>GitHub: <a href=\"https://www.2log.io\">https://www.2log.io</a>  <br><br> Eine Aufstellung von Drittsoftware und den verwendeten Lizenzen findest Du hier <a href=\"https://github.com/2log-io/2log.io#license-notice\">hier.</a>")
    }
}
