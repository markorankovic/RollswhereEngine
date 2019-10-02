import Smorgasbord
import GameplayKit

class MovingState: GameState {
    override func didEnter(from previousState: GKState?) {
        print("moving")
    }
    override func keyDown(event: NSEvent) {
        (self.stateMachine as? GameStateMachine)?.shootable?.keyDown(event)
    }
    override func update(deltaTime seconds: TimeInterval) {
        DispatchQueue.main.async {
            (self.stateMachine as? GameStateMachine)?.shootable?.enterReadyIfRested()
        }
    }
}

