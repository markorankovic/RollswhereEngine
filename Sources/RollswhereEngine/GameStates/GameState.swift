import SpriteKit
import GameplayKit

class GameState: GKState {
    
    var game: Game?
    
    var scene: GameScene? {
        game?.currentGameScene
    }
    
    convenience init(game: Game) {
        self.init()
        self.game = game
    }
    
    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) { }
    
    func keyDown(event: NSEvent) { }
    
    func keyUp(event: NSEvent) { }
    
}
