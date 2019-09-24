import SpriteKit
import GameplayKit

class GameState: GKState {
        
    var scene: GameScene? {
        return game?.currentGameScene
    }
    
    var game: Game? {
        return (stateMachine as? GameStateMachine)?.game
    }
    
    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) { }
    
    func keyDown(event: NSEvent) { }
    
    func keyUp(event: NSEvent) { }
    
}
