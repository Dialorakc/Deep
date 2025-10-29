import Quickshell
import QtQuick
import qs.config
import qs.settings
import "./bars"

Scope {
    id: root

    readonly property int spacing: 15

    Bezzel {
        anchors { top: true; left: true; right: true}
        exclusiveZone: winLoad.isTiled ? spacing : 0
    }
    PanelWindow {
        id: main

        mask: Region { item: reel.item || reev.item && swiching.switcher }
        anchors {top: true; left: true; right: true; bottom: true}
        exclusiveZone: winLoad.isTiled ? spacing : 0
        color: Colour.trans

        WindowLoader {id: winLoad}
        Zone{
            id: swiching
            z: 1

            Component.onCompleted: {
                switcher.width = 50
                switcher.height = 20
                switcher.x = Screen.width - 50
                switcher.y = Screen.height - 40
                switcher.color = Colour.lime
            }
        }

        Loader {
            id: reev
            active: winLoad.isTiled
            sourceComponent: HomeBar{id: homeBar; z: 0}
        }
        Loader {
            id: reel
            active: !winLoad.isTiled
            sourceComponent: HoverBar{id: hoverBar; z: 0}
        }
    }
}
