import SpriteKit
import GameplayKit
import Smorgasbord

class ReadyState: GameState {
    
    override func didEnter(from previousState: GKState?) {
        print("Ready to shoot")
    }
    
    override func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        (stateMachine as? GameStateMachine)?.shootable?.panGestureHandler(gestureRecognizer)
    }

    override func keyDown(event: NSEvent) {
        (stateMachine as? GameStateMachine)?.shootable?.keyDown(event)
    }
    
    override func keyUp(event: NSEvent) {
        (stateMachine as? GameStateMachine)?.shootable?.keyUp(event)
        print("key is up")
    }
    
}
