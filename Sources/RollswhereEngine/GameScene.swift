import SpriteKit
import GameplayKit

open class GameScene: SKScene {
    
    open override func didMove(to view: SKView) {
        physicsWorld.speed = 1
        anchorPoint = .init(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
    }
        
    public var game: Game? {
        if let g = (view as? GameView)?.game {
            return g
        } else {
            return nil
        }
    }
    
    var state: GameState? {
        return game?.stateMachine?.currentState as? GameState
    }
    
    override public func keyDown(with event: NSEvent) {
        state?.keyDown(event: event)
        print(state)
    }
    
    override public func keyUp(with event: NSEvent) {
        state?.keyUp(event: event)
    }
    
    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        //print("Pan loc: \(gestureRecognizer.location(in: view))")
        state?.panGestureHandler(gestureRecognizer)
    }
    
    override public func update(_ currentTime: TimeInterval) {
        game?.stateMachine?.update(deltaTime: currentTime)
    }
    
}
