import QtQuick
import "."

Item {
    id: root

    property int bposy: 0
    property int bposx: 0
    property int curve: 0
    property alias fullBorder: main
    property alias flowBorder: sub
    property alias hangBorder: subMain
    property color colouring: "#ffffff"

    width: Screen.width; height: Screen.height
    Canvas {
        id: main

        anchors.fill: parent
        visible: false
        onPaint: {
            var rend = getContext("2d")

            rend.lineWidth = 0.5
            rend.strokeStyle = colouring
            rend.fillStyle = colouring
            rend.font = 'bold 50px BitPap'
            rend.strokeText("Sup", Screen.width / 1.3, 1000)

            rend.beginPath()
            rend.moveTo(0, 30)
            rend.arcTo(0, 0, 30, 0, curve)
            rend.lineTo(0, 0)
            rend.lineTo(0, 30)
            rend.moveTo(Screen.width, 30)
            rend.arcTo(Screen.width, 0, Screen.width - 30, 0, curve)
            rend.lineTo(Screen.width, 0)
            rend.lineTo(Screen.width, 30)
            rend.moveTo(0, Screen.height - 30)
            rend.arcTo(0, Screen.height, 30, Screen.height, curve)
            rend.lineTo(0, Screen.height)
            rend.lineTo(0, Screen.height - 30)
            rend.moveTo(Screen.width, Screen.height - 30)
            rend.arcTo(Screen.width, Screen.height, Screen.width - 30, Screen.height, curve)
            rend.lineTo(Screen.width, Screen.height)
            rend.lineTo(Screen.width,Screen.height - 30)
            rend.closePath()
            rend.stroke()
            rend.fill()
        }
    }
    Canvas {
        id: subMain

        anchors.fill: parent
        visible: false
        onPaint: {
            var rend = getContext("2d")

            rend.lineWidth = 0.5
            rend.strokeStyle = root.colouring
            rend.fillStyle = root.colouring

            rend.beginPath()
            rend.moveTo(0, root.bposy + 30)
            rend.arcTo(0, root.bposy, 30, root.bposy, curve)
            rend.lineTo(0, root.bposy)
            rend.lineTo(0, root.bposy + 30)
            rend.moveTo(Screen.width, root.bposy + 30)
            rend.arcTo(Screen.width, root.bposy, Screen.width - 30, root.bposy, curve)
            rend.lineTo(Screen.width, root.bposy)
            rend.lineTo(Screen.width, root.bposy + 30)
            rend.closePath()
            rend.stroke()
            rend.fill()
        }
    }
    Canvas {
        id: sub

        anchors.fill: parent
        visible: false
        onPaint: {
            var rend = getContext("2d")

            rend.lineWidth = 1
            rend.strokeStyle = colouring
            rend.fillStyle = colouring

            rend.beginPath()
            rend.moveTo(0, 80)
            rend.arcTo(170, 180, 80, 200, Math.PI * 2)
            rend.lineTo(50, 300)
            rend.lineTo(0, 350)
            rend.closePath()
            rend.stroke()
            rend.fill()
        }
    }
}
