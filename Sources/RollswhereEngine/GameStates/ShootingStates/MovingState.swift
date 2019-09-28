import Smorgasbord
import GameplayKit

class MovingState: GameState {
        
    override func didEnter(from previousState: GKState?) {
        print("moving")
    }
    
    override func keyDown(event: NSEvent) {
        (stateMachine as? GameStateMachine)?.shootable?.returnIfSpecifiedKeyPressed(event: event)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        DispatchQueue.main.async {
            (self.stateMachine as? GameStateMachine)?.shootable?.enterReadyIfRested()
        }
    }

}

