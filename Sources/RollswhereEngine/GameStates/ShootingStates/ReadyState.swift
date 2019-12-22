import SpriteKit
import GameplayKit
//import Smorgasbord

class ReadyState: GameState {
    override func didEnter(from previousState: GKState?) {
        print("Ready to shoot")
        (stateMachine as? GameStateMachine)?.shootable?.resetRotation()
        (stateMachine as? GameStateMachine)?.shootable?.activatePhysics()
    }
    override func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        (stateMachine as? GameStateMachine)?.shootable?.panGestureHandler(gestureRecognizer)
    }
}
