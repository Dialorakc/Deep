pragma ComponentBehavior: Bound

import Quickshell.Io
import QtQuick

Text {
    id: windowChecker
    property bool isTiled: tiledCount > 0
    property bool isFull: fullCount == 2
    property int isWindow: 0
    property int tiledCount: 0
    property int fullCount: 0

    Process {
        id: windowStateProcess
        command: ["bash", "-c", "$HOME/deep/config/scripts/windowState.sh"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split('\n');
                lines.forEach(line => {
                    const parts = line.split(': ');
                    if (parts.length === 2) {
                        const value = parseInt(parts[1]);
                        if (!isNaN(value)) {
                            switch(parts[0]) {
                                case 'windows':
                                    windowChecker.isWindow = value;
                                    break;
                                case 'tiled':
                                    windowChecker.tiledCount = value;
                                    break;
                                case 'fullscreen':
                                    windowChecker.fullCount = value;
                                    break;
                            }
                        }
                    }
                });
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: windowStateProcess.running = true
    }
}
