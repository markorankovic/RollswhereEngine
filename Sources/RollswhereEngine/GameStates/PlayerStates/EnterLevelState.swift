import SpriteKit
import GameplayKit

class EnterLevelState: GameState {
        
    override func didEnter(from previousState: GKState?) {
        print("Entering level")
                
        stateMachine?.enter(RetryState.self)
    }
    
}
