import SpriteKit
import GameplayKit
import Smorgasbord

class ReadyState: GameState {
    
    override func didEnter(from previousState: GKState?) {
        print("Ready to shoot")
    }
    
    override func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        (stateMachine as? GameStateMachine)?.player?.panGestureHandler(gestureRecognizer)
    }

    override func keyDown(event: NSEvent) {
        
        //(stateMachine as? GameStateMachine)?.player.keyDown(event, stateMachine)

        //for rotation in game?.rotations ?? [] {
       //     rotation.keyDown(event: event)
        //}
        
    }
    
    override func keyUp(event: NSEvent) {
       // (stateMachine as? GameStateMachine)?.player.keyUp(event, stateMachine)
       // for rotation in game?.rotations ?? [] {
      //      rotation.keyUp(event: event)
      //  }
                
    }
    
}
