pragma Singleton

import QtQuick

QtObject {
    id: globalState

    property real scale: 1.5
    property real time: Date.now() / 2000

    property Timer ticker: Timer {
        interval: 500
        running: true
        repeat: true

        onTriggered: {
            // Increment time
            globalState.time = Date.now() / 2000
        }
    }
}
