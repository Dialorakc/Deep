pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import QtQuick

MouseArea {
    id: root

    property int spaceIndex: 1
    property int wsId: spaceIndex
    property bool isActive: Hyprland.focusedWorkspace?.id === wsId
    property bool isOccupied: Hyprland.workspaces.values.some(ws => ws.id === wsId)

    cursorShape: Qt.PointingHandCursor
    anchors.fill: parent

    onClicked: Hyprland.dispatch(`workspace ${wsId}`)
}

