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
        camera?.constraints = [
            SKConstraint.positionX(.init(lowerLimit: minX + size.width / 4, upperLimit: maxX - size.width / 2)),
            SKConstraint.positionY(.init(lowerLimit: 0, upperLimit: 0))
        ]
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
    
    func returnCam() {
        camera?.run(.move(to: .init(), duration: 1))
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
