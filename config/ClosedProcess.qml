pragma ComponentBehavior: Bound

import Quickshell.Io
import QtQuick
import qs.settings

Item {
    id: root

    property int iconSize: 120 * GlobalState.scale
    property int spacing: 20
    property var seenFiles: ({})
    property var iconStates: ({}) // Store: fileName -> {scale, completed, creationTime}

    width: Screen.width
    height: Screen.height

    function refreshIcons() {
        lister.running = true
    }
    function loadIconStates() {
        stateLoader.running = true
    }
    function saveIconState(fileName, creationTime, completed) {
        let stateFile = "/tmp/quickshell_closed/.state_" + fileName
        let content = creationTime + "|" + (completed ? "1" : "0")

        stateSaver.command = ["bash", "-c", "echo '" + content + "' > " + stateFile]
        stateSaver.running = true
    }
    function getCreationTime(fileName) {
        if (iconStates[fileName]) {
            return iconStates[fileName].creationTime
        }
        return GlobalState.time // New icon, use current time
    }
    function isCompleted(fileName) {
        if (iconStates[fileName]) {
            return iconStates[fileName].completed
        }
        return false
    }
    function deleteFile(fileName) {
        deleter.command = ["bash", "-c", "rm -rf '/tmp/quickshell_closed/" + fileName + "' '/tmp/quickshell_closed/.state_" + fileName + "'"]
        deleter.running = true

        delete seenFiles[fileName]
        delete iconStates[fileName]
    }
    function spawnPosition(index) {
        let positions = [
            {x: 50, y: Screen.height - 50},
            {x: Screen.width / 4, y: Screen.height - 50},
            {x: Screen.width / 6, y: Screen.height - 50},
            {x: 100, y: Screen.height - 100},
        ]
        return positions[index % positions.length]
    }

    Item {
        id: iconContainer
        anchors.fill: parent
    }

    /* Processes */
    Process { id: deleter }
    Process { id: stateSaver }
    Process {
        id: monitor
        command: ["bash", "-c", "$HOME/deep/config/scripts/closedProcess.sh"]
        running: true
    }
    Process {
        id: watcher
        command: ["bash", "-c", "while inotifywait -e create,modify /tmp/quickshell_closed/ 2>/dev/null; do echo CHANGED; done"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                refreshIcons()
            }
        }

        Component.onCompleted: {
            loadIconStates()
            refreshIcons()
        }
    }
    Process {
        id: stateLoader
        command: ["bash", "-c", "cd /tmp/quickshell_closed/ 2>/dev/null && for f in .state_*; do [ -f \"$f\" ] && echo \"${f#.state_}:$(cat \"$f\")\"; done || true"]

        stdout: SplitParser {
            onRead: data => {
                let lines = data.trim().split("\n").filter(l => l.length > 0)

                for (let i = 0; i < lines.length; i++) {
                    let parts = lines[i].split(":")
                    if (parts.length === 2) {
                        let fileName = parts[0]
                        let stateParts = parts[1].split("|")
                        if (stateParts.length === 2) {
                            iconStates[fileName] = {
                                creationTime: parseFloat(stateParts[0]),
                                completed: stateParts[1] === "1"
                            }
                        }
                    }
                }
            }
        }
    }
    Process {
        id: lister
        command: ["bash", "-c", "cd /tmp/quickshell_closed/ 2>/dev/null && ls -1t | grep -v '^\\.state_' | tac || true"]

        stdout: SplitParser {
            onRead: data => {
                let files = data.trim().split("\n").filter(f => f.length > 0)

                for (let i = 0; i < files.length; i++) {
                    let fileName = files[i]

                    if (isCompleted(fileName)) {
                        seenFiles[fileName] = true
                        continue
                    }

                    // Only create if we haven't seen this file before
                    if (!seenFiles[fileName]) {
                        seenFiles[fileName] = true

                        let appName = fileName.replace(/_\d+$/, '')
                        let iconCount = iconContainer.children.length
                        let creationTime = getCreationTime(fileName)
                        let spawnPos = spawnPosition(iconCount)
                        console.log("NEW FILE:", fileName, "Creating icon", iconCount, "for", appName)

                        iconComponent.createObject(iconContainer, {
                            x: spawnPos.x,
                            y: spawnPos.y,
                            iconName: appName,
                            fileName: fileName,
                            creationTime: creationTime
                        })
                    }
                }
            }
        }
    }

    Component {
        id: iconComponent

        Image {
            id: iconImage

            property string iconName: ""
            property string fileName: ""
            readonly property real creationTime: GlobalState.time
            property real age: GlobalState.time - creationTime
            property real computedScale: Math.max(0.03, 1.0 - ((age / 2) / 100.0))
            property bool isCompleted: computedScale <= 0.03

            width: root.iconSize; height: root.iconSize
            scale: computedScale * GlobalState.scale
            visible: !isCompleted && scale > 0.05

            source: "image://icon/" + iconName
            fillMode: Image.PreserveAspectFit
            cache: true
            smooth: false
            asynchronous: true

            onIsCompletedChanged: {
                if (isCompleted) {
                    console.log("Icon completed:", fileName, "- deleting file")
                    root.deleteFile(fileName)
                    destroyTimer.start()
                }
            }

            Timer {
                id: destroyTimer
                interval: 500
                onTriggered: iconImage.destroy()
            }
            // Save state periodically
            Timer {
                interval: 2000
                running: !iconImage.isCompleted
                repeat: true
                onTriggered: {
                    root.saveIconState(iconImage.fileName, iconImage.creationTime, iconImage.isCompleted)
                }
            }

            Component.onCompleted: {
                console.log("Icon created:", iconName, "from file:", fileName, "at time:", creationTime, "age:", age)
            }
            Component.onDestruction: {
                root.saveIconState(fileName, creationTime, isCompleted)
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: refreshIcons()
    }
}
