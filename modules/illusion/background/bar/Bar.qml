import Quickshell
import QtQuick
import qs.config
import "./bars"

Scope {
    id: root

    readonly property int spacing: 30

    Bezzel {
        anchors{ top: true; left: true; right: true}
        exclusiveZone: winLoad.isTiled ? spacing : 0
    }

    PanelWindow{
        id: main
        mask: Region{item: reel.item || reev.item}

        WindowLoader{ id: winLoad}

        property int pinx: Screen.width
        property int piny: Screen.height

        anchors{ top: true; left: true; right: true; bottom: true}
        exclusiveZone: winLoad.isTiled ? spacing : 0
        aboveWindows: true
        color: Colour.trans

        Loader {
            id: reel
            active: !winLoad.isTiled
            sourceComponent: HoverBar{ id: home; x: home.cin / 2; y: main.piny - 65}
        }
        Loader {
            id: reev
            active: winLoad.isTiled
            sourceComponent: HomeBar{ id: hover}
        }
    }
}

