import SpriteKit
import AppKit

func createArc(deltaAngle: CGFloat) -> CGMutablePath {
    let arcPath = CGMutablePath()
    arcPath.addRelativeArc(center: .init(), radius: 50, startAngle: .pi/2, delta: -deltaAngle)
    return arcPath
}

func createPowerBar(deltaAngle: CGFloat) -> SKShapeNode {
    let powerBar = SKShapeNode()
    powerBar.path = createArc(deltaAngle: deltaAngle)
    powerBar.strokeColor = .red
    return powerBar
}

let ball = SKShapeNode(circleOfRadius: 50)

func updatePowerBar(deltaAngle: CGFloat) {
    ball.removeAllChildren()
    ball.addChild(createPowerBar(deltaAngle: deltaAngle))
}

updatePowerBar(deltaAngle: 0)
ball

updatePowerBar(deltaAngle: 1)
ball

updatePowerBar(deltaAngle: 2)
ball

updatePowerBar(deltaAngle: 3)
ball

updatePowerBar(deltaAngle: 4)
ball

updatePowerBar(deltaAngle: 5)
ball

updatePowerBar(deltaAngle: 2 * .pi)
ball
