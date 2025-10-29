import QtQuick
import qs.config
import qs.settings

Item {
    id: root

    readonly property real holeX: Screen.width / 1.6
    readonly property real holeY: 350
    readonly property int radius: 50
    readonly property real radiusSquared: radius * radius
    readonly property real gravity: 200

    readonly property var waypointLibrary: [
        {x: Screen.width / 1.0, y: 450},
        {x: Screen.width / 1.09, y: 300},
        {x: Screen.width / 1.1, y: 350},
        {x: Screen.width / 0.98, y: 320},
        {x: Screen.width / 1.05, y: 400},
        {x: Screen.width / 1.2, y: 280},
        {x: Screen.width / 1.15, y: 320}
    ]
    readonly property var speeds: [ -0.045, -0.03, -0.04, -0.035, -0.028 ]
    readonly property real stage1ToStage2_X: Screen.width / 1.6
    readonly property real stage2ToStage3_Y: 500
    readonly property real stage1CeilingY: 800

    width: Screen.width
    height: Screen.height

    ClosedProcess {
        id: icons

        property var velocity: ({})
        property var lastUpdateTime: ({})
        property var assignedWaypoints: ({})
        property var speedUpdate: ({})

        x: 0; y: 0

        function getVelocity(index) {
            if (!velocity[index]) {
                velocity[index] = {vx: 0, vy: 0}
            }
            return velocity[index]
        }
        function getLastUpdateTime(index) {
            if (!lastUpdateTime[index]) {
                lastUpdateTime[index] = GlobalState.time
            }
            return lastUpdateTime[index]
        }
        function setLastUpdateTime(index, time) {
            lastUpdateTime[index] = time
        }
        function getWaypoint(index) {
            if (!assignedWaypoints[index]) {
                let randomIndex = Math.floor(Math.random() * root.waypointLibrary.length)
                assignedWaypoints[index] = root.waypointLibrary[randomIndex]
            }
            return assignedWaypoints[index]
        }
        function speedUpdating(index) {
            if (!speedUpdate[index]) {
                let randomIndex = Math.floor(Math.random() * root.speeds.length)
                speedUpdate[index] = root.speeds[randomIndex]
            }
            return speedUpdate[index]
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            let container = icons.children[0]

            if (!container || container.children.length === 0) return
            let currentTime = GlobalState.time
            let iconCount = container.children.length

            // Cache frequently-used values
            let hX = root.holeX
            let hY = root.holeY
            let grav = root.gravity

            // Stages
            const accX = 0.12
            const ceilingPush = 0.08
            const dragX = 0.7
            const dragY = 0.7

            const waypointPull = 0.25
            const altDragX = 0.8
            const altDragY = 0.75

            const forceMultiplier = 3
            const finalDrag = 0.98

            for (let i = 0; i < iconCount; i++) {

                let icon = container.children[i]
                if (!icon || !icon.visible) continue

                let myWaypoint = icons.getWaypoint(i)
                let speed = icons.speedUpdating(i)

                let wpX = myWaypoint.x
                let wpY = myWaypoint.y
                let upwardDrift = speed

                // Handle laptop sleep (closed lid)
                let lastTime = icons.getLastUpdateTime(i)
                let deltaTime = currentTime - lastTime
                deltaTime = Math.min(deltaTime, 5)  // Cap at 5 seconds
                let framesToSimulate = Math.max(1, Math.floor(deltaTime / 0.03))
                icons.setLastUpdateTime(i, currentTime)

                // Calculate icon center position
                let halfWidth = icon.width * 0.5
                let iconX = icon.x + icons.x + halfWidth
                let iconY = icon.y + icons.y + halfWidth

                let vel = icons.getVelocity(i)

                // Simulate all missed frames
                for (let frame = 0; frame < framesToSimulate; frame++) {
                    let dx = hX - iconX
                    let dy = hY - iconY
                    let distanceSquared = dx * dx + dy * dy

                    if (distanceSquared < root.radiusSquared) {
                        icon.opacity = Math.max(0, icon.opacity - 0.05)
                        break
                    }

                    let distance = Math.sqrt(distanceSquared)

                    // Stage 1
                    if (iconX < root.stage1ToStage2_X) {
                        if (iconY < root.stage1CeilingY) {
                            vel.vy += ceilingPush
                        }

                        vel.vx += accX
                        vel.vy += upwardDrift

                        vel.vx *= dragX
                        vel.vy *= dragY
                    }
                    // Stage 2
                    else if (iconY > root.stage2ToStage3_Y) {
                        // Calculate direction vector TO waypoint
                        let toWaypointX = wpX - iconX
                        let toWaypointY = wpY - iconY
                        let distanceToWaypoint = Math.sqrt( toWaypointX * toWaypointX + toWaypointY * toWaypointY)
                        let directionX = toWaypointX / distanceToWaypoint
                        let directionY = toWaypointY / distanceToWaypoint

                        vel.vx += directionX * waypointPull
                        vel.vy += directionY * waypointPull

                        vel.vx *= altDragX
                        vel.vy *= altDragY
                    }
                    // Stage 3
                    else {
                        // Calculate direction to black hole
                        let toHoleX = hX - iconX
                        let toHoleY = hY - iconY
                        let distToHoleSquared = toHoleX * toHoleX + toHoleY * toHoleY
                        let distToHole = Math.sqrt(distToHoleSquared)

                        // Inverse square law: force = gravity / distance²
                        // The closer you are, the stronger the pull
                        let force = grav / distToHoleSquared

                        // Normalize and scale by force multiplier
                        let invDistance = forceMultiplier / distToHole
                        let forceX = (toHoleX * invDistance) * force
                        let forceY = (toHoleY * invDistance) * force

                        // Apply force and heavy drag (prevents spiraling)
                        vel.vx = (vel.vx + forceX) * finalDrag
                        vel.vy = (vel.vy + forceY) * finalDrag
                    }

                    icon.x += vel.vx
                    icon.y += vel.vy
                    // Update cached position for next frame
                    iconX = icon.x + icons.x + halfWidth
                    iconY = icon.y + icons.y + halfWidth
                }
            }
        }
    }
}
