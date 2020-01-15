import SpriteKit
import GameplayKit

open class GameScene: SKScene {
    
    open override func didMove(to view: SKView) {
        physicsWorld.speed = 1
        scaleMode = .aspectFill
    }
    
    func followShootable(shootable: ShootableComponent) {
        guard let p = shootable.nodeComponent?.node.position else {
            return
        }
        guard let camera = camera else {
            return
        }
        if (p.x > camera.position.x) {
            camera.run(.move(to: p, duration: 0.3))
        }
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
