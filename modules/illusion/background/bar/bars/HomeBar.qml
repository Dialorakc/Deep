import QtQuick
import qs.config

Rectangle {
    id: root

    readonly property int cin: Screen.width

    Zone {
        id: switching
        Component.onCompleted: {
            switcher.width = 30
            switcher.height = 25
            switcher.x = Screen.width - switcher.width
            switcher.y = 0
            switcher.color = Colour.hull
        }
    }

    Border {
        id: border
        hangBorder.visible: true
        bposy: root.height
        curve: 25
        colouring: root.color
    }
    width: cin; height: 25
    color: Colour.hell
}
