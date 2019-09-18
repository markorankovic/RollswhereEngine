import SpriteKit
import PlaygroundSupport


class GameScene: SKScene {
    
    let sq1 = SKShapeNode(rect: .init(x: -15, y: -2.5, width: 50, height: 7))
    
    let sq2 = SKShapeNode(rect: .init(x: -15, y: -5, width: 43, height: 15))
    
    override func didMove(to view: SKView) {
        backgroundColor = .brown
        sq1.position.y -= 50
        sq2.position.y += 50
        addChild(sq1)
        addChild(sq2)
    }
}

let scene = { () -> GameScene in
    let s = GameScene()
    s.anchorPoint = .init(x: 0.5, y: 0.5)
    s.scaleMode = .resizeFill
    return s
}()

let view = SKView(frame: .init(x: 0, y: 0, width: 500, height: 500))

view.presentScene(scene)

PlaygroundPage.current.liveView = view
