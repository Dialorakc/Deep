import Quickshell
import QtQuick
import qs.config
import qs.modules.void.wallpaper.blackhole

PanelWindow{
    id: root

    anchors {top: true; left: true; right: true; bottom: true }
    aboveWindows: false
    exclusionMode: ExclusionMode.Ignore
    color: Colour.trans
    visible: false

    Rectangle {
        id: hole

        width: 100; height: 100; radius: 50
        x: Screen.width / 1.7; y: 320
        color: "#ffffff"
    }

    BlackHole {}
}
