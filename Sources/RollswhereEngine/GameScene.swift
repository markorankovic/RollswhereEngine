import SpriteKit
import GameplayKit

open class GameScene: SKScene {
    
    var minX: CGFloat {
        -size.width / 4
    }
    
    var maxX: CGFloat {
        size.width + size.width / 2
    }
    
    var minY: CGFloat {
        -size.height / 2
    }
    
    var maxY: CGFloat {
        size.height / 2
    }
    
    open override func didMove(to view: SKView) {
        physicsWorld.speed = 1
        if let backgroundNode = childNode(withName: "background") {
            let backgroundMinX = -backgroundNode.frame.size.width/2
            let backgroundMaxX = backgroundNode.frame.size.width/2
            let backgroundMinY = -backgroundNode.frame.size.height/2
            let backgroundMaxY = backgroundNode.frame.size.height/2
            camera?.constraints = [
                SKConstraint.positionX(.init(lowerLimit: backgroundMinX + size.width/2, upperLimit: backgroundMaxX - size.width/2)),
                SKConstraint.positionY(.init(lowerLimit: backgroundMinY + size.height/2, upperLimit: backgroundMaxY - size.height/2)),
            ]
        }
    }
    
    func followShootable(shootable: ShootableComponent) {
        guard let p = shootable.nodeComponent?.node.position else {
            return
        }
        moveTowardPosition(p)
    }
    
    func moveTowardPosition(_ p: CGPoint) {
        guard let camera = camera else {
            return
        }
        camera.run(.move(to: p, duration: 0.3))
    }
    
    func returnCam(shootable: ShootableComponent) {
        guard let pos = shootable.nodeComponent?.node.position else {
            return
        }
        camera?.run(.move(to: pos, duration: 1))
    }
    
    public var game: Game? {
        if let g = (view as? GameView)?.game {
            return g
        } else {
            return nil
        }
    }
    
    var state: GameState? { return game?.stateMachine?.currentState as? GameState }
    
    override public func keyDown(with event: NSEvent) { state?.keyDown(event: event) }
    
    open override func mouseMoved(with event: NSEvent) {
        state?.mouseMoved(event: event)
    }
    
    override public func keyUp(with event: NSEvent) {
        state?.keyUp(event: event)
        print("key released")
    }
    
    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        state?.panGestureHandler(gestureRecognizer)
    }
    
    override public func update(_ currentTime: TimeInterval) {
        for shootable in (game?.each(ShootableComponent.self) ?? []) {
            shootable.updateVisibility()
        }
        state?.update(deltaTime: currentTime)
    }
    
}
