import SpriteKit
import GameplayKit
//import Smorgasbord

class ReadyState: GameState {
    override func didEnter(from previousState: GKState?) {
        print("Ready to shoot")
        guard let shootable = (stateMachine as? GameStateMachine)?.shootable else {
            return
        }
        
        shootable.resetRotation()
        shootable.activatePhysics()
        (game?.currentLevel?.gamescene.rootNode as? GameScene)?.returnCam(shootable: shootable)
    }
    override func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        (stateMachine as? GameStateMachine)?.shootable?.panGestureHandler(gestureRecognizer)
    }
}
