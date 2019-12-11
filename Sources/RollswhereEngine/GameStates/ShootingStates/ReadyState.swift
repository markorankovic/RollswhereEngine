import SpriteKit
import GameplayKit
//import Smorgasbord

class ReadyState: GameState {
    override func didEnter(from previousState: GKState?) {
        (stateMachine as? GameStateMachine)?.shootable?.resetRotation()
        print("Ready to shoot")
    }
    override func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        (stateMachine as? GameStateMachine)?.shootable?.panGestureHandler(gestureRecognizer)
    }
}
