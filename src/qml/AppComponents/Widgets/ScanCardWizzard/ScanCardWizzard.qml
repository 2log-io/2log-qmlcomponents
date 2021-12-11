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

    Component.onCompleted: {
        if (isMobile && nfcReader.ready) {
            if (stack.depth > 1)
                stack.clear()

            stack.replace(scanCardPage)
        }
    }

    onManualChanged: {
        if (stack.depth > 1)
            stack.clear()
        if (!manual) {
            if (reader.ready) {
                stack.replace(scanCardPage)
            } else {
                stack.replace(message)
            }
        } else {
            stack.replace(keyboardCardPage)
        }
    }

    property bool parentStackActive: StackView.status == StackView.Active

    Stack {
        id: stack
        anchors.fill: parent
        initialItem: docroot.manual ? undefined : scanCardPage
    }

    Component {
        id: scanCardPage
        ScanCardPage {
            reader: docroot.reader
            onConfirm: docroot.confirm(cardID)
            onCancel: stack.depth > 1 ? stack.pop() : docroot.cancel()
        }
    }

    Component {
        id: message

        MessagePage {
            message: qsTr("Momentan ist leider kein Dot zum Einlesen von Karten konfiguriert. Dies kann im Administrationsbereich geändert werden.")
            onConfirm: docroot.confirm(cardID)
            onCancel: stack.depth > 1 ? stack.pop() : docroot.cancel()
        }
    }

    Component {
        id: keyboardCardPage
        TextFieldCardPage {
            onConfirm: docroot.confirm(cardID)
            onCancel: stack.depth > 1 ? stack.pop() : docroot.cancel()
        }
    }
}
