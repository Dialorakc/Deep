pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import qs.settings

Item {
    id: root

    property alias switcher: switchin

    Rectangle {
        id: switchin
        color: "#ef0b0b"

        MouseArea {
            id: swiss
            anchors.fill: parent

            onClicked: {
                console.log("Switching bar...")
                Switcher.zoneSwitch()
            }
        }
    }
}
