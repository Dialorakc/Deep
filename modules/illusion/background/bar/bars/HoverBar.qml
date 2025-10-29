import QtQuick
import qs.config
import "../items/workspace"

Rectangle {
    id: root

    readonly property int con: Screen.height - 1040
    property int cin: 100
    readonly property int posy: Screen.width - cin

    Zone {
        id: switching
        Component.onCompleted: {
            switcher.width = 50
            switcher.height = 50
            switcher.x = root.posy
            switcher.y = root.posy
            switcher.color = Colour.must
        }
    }

    width: posy; height: con
    color: Colour.blaze

    Workspaces{ id: workspace; x: root.posy / 5; cin: root.con}
}
