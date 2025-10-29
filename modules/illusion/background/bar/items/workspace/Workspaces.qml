import QtQuick
import qs.config
import qs.config.items

Rectangle {
    id: root

    property int spaces: 10
    property int gap: 26
    property int posx: 8
    property int posy: 4
    property int alty: 8
    property int con: 600
    property int cin: 0

    width: con; height: cin
    color: Colour.hell

    Row {
        spacing: gap
        x: posx; y: 1

        Repeater {
            model: root.spaces

            Rectangle {
                id: deck

                required property int index
                Ws{
                    id: space
                    spaceIndex: index + 1
                    onClicked: {
                        deck.width = isActive ? 35 : (isOccupied ? 10 : 35)
                    }
                }
                width: 35; height: 38;
                color: space.isActive ? Colour.foreground: (space.isOccupied ? Colour.lime : Colour.must)

                Behavior on width{
                    NumberAnimation{ duration: 300; easing.type: Easing.OutQuad}
                }
            }
        }
    }
}
