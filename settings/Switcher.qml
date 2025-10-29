pragma Singleton

import QtQuick

QtObject {
    property int currentZone: 0

    signal switchZone()

    function zoneSwitch() {
        if(currentZone >= 1) {
            currentZone = 0
        } else {
            currentZone++
        }
        console.log("Switched to bar:", currentZone)
    }
}
