import Quickshell
import QtQuick
import qs.config
import qs.settings
import qs.modules.illusion as Illusion
import qs.modules.void as Void

Scope {
    Loader {
        active: Switcher.currentZone == 0
        sourceComponent: Illusion.Init{}

        onLoaded: console.log("Illusion bar loaded")
    }

    Loader {
        active: Switcher.currentZone == 1
        sourceComponent: Void.Init{}

        onLoaded: console.log("Void bar loaded")
    }
    Empty {id: empty; visible: Switcher.currentZone == 1}
}
