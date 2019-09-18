import SpriteKit
import GameplayKit
import Smorgasbord

class ReadyState: GameState {
    
    override func didEnter(from previousState: GKState?) {
        
        guard let game = game else {
            return
        }

        for shootable in game.shootables {
            shootable.entityPhysicsComponent?.stopMovement()
            print("Ready to shoot")
        }
        
    }
    
    override func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        
        for shootable in game?.shootables ?? [] {
            shootable.panGestureHandler(gestureRecognizer)
        }
        
        for draggable in game?.draggables ?? [] {
            draggable.panGestureHandler(gestureRecognizer)
        }
        
        for rotation in game?.rotations ?? [] {
            rotation.panGestureHandler(gestureRecognizer)
        }

    }
    
    override func keyDown(event: NSEvent) {
        
        for rotation in game?.rotations ?? [] {
            rotation.keyDown(event: event)
        }
        
    }
    
    override func keyUp(event: NSEvent) {
        
        for rotation in game?.rotations ?? [] {
            rotation.keyUp(event: event)
        }
                
    }
    
}
