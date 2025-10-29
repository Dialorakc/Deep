import QtQuick
import qs.config

Item {
    // top
    Rectangle {
        id: rit

        width: Screen.width / 5; height: 40; radius: 40
        //x: -20; y: 0
        x: 0; y: -10
        color: Colour.lime
    }
    Rectangle {
        id: ritCorner

        width: Screen.width / 8; height: 85; rotation: -50
        x: -120; y: -5
        color: Colour.hell
    }

    // bottom
    Rectangle {
        id: root

        width: Screen.width / 7; height: 40; radius: 40
        x: Screen.width - width; y: Screen.height - height
        color: Colour.hell
    }
}
