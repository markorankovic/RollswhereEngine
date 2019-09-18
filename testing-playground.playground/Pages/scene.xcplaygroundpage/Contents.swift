import SpriteKit
import PlaygroundSupport

let view = SKView(
    frame: .init(
        x: 0,
        y: 0,
        width: 500,
        height: 500
    )
)

class GameScene: SKScene {
    
    let ball = { () -> SKShapeNode in
        let r: CGFloat = 10
        let n = SKShapeNode(circleOfRadius: r)
        n.fillColor = .brown
        n.physicsBody = SKPhysicsBody(circleOfRadius: r)
        return n
    }()
    
    override func didMove(to view: SKView) {
        backgroundColor = .blue
        addChild(ball)
    }
    
}

let scene = GameScene(size: view.frame.size)

scene.anchorPoint = .init(x: 0.5, y: 0.5)

scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
    
view.presentScene(scene)

PlaygroundPage.current.liveView = view
