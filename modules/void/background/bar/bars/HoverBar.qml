import QtQuick
import qs.config

Rectangle {
    id: root

    Border {
        id: border
        colouring: Colour.white
        curve: 80
        //fullBorder.visible: true
        flowBorder.visible: true
    }
    width: Screen.width; height: Screen.height
    color: Colour.trans
}
