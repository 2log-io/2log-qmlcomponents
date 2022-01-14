import QtQuick 2.5
import QtQuick 2.5
import CloudAccess 1.0
import QtQuick.Controls 2.3
import UIControls 1.0

Item {
    id: docroot
    property CardReader reader
    signal confirm(string cardID)
    signal cancel
    property bool manual: !reader.ready
    property Component currentComponent
    onCurrentComponentChanged: stack.replace(currentComponent)
    Component.onCompleted: {
        if (isMobile && nfcReader.ready) {
            docroot.currentComponent = scanCardPage
        }
    }

    onManualChanged: {
        if (!manual) {
            console.log("A")
            if (reader.ready) {
                docroot.currentComponent = scanCardPage
            } else {
                docroot.currentComponent = message
            }
        } else {
            docroot.currentComponent = keyboardCardPage
        }
    }

    property bool parentStackActive: StackView.status == StackView.Active

    Stack {
        id: stack
        anchors.fill: parent
        initialItem: dummy
        Component.onCompleted: stack.push(docroot.currentComponent)
    }
    Component {
        id: dummy
        Item {}
    }

    Component {
        id: scanCardPage
        ScanCardPage {
            reader: docroot.reader
            onConfirm: docroot.confirm(cardID)
            onCancel: docroot.cancel()
        }
    }

    Component {
        id: message

        MessagePage {
            message: qsTr("Momentan ist leider kein Dot zum Einlesen von Karten konfiguriert. Dies kann im Administrationsbereich geändert werden.")
            onConfirm: docroot.confirm(cardID)
            onCancel: docroot.cancel()
        }
    }

    Component {
        id: keyboardCardPage
        TextFieldCardPage {
            onConfirm: docroot.confirm(cardID)
            onCancel: docroot.cancel()
        }
    }
}
