import Smorgasbord
import GameplayKit

class MovingState: GameState {
    
    func resetVelocities() {
        guard let game = game else {
            return
        }
        
        for shootable in game.shootables {
            shootable.entityPhysicsComponent?.setVelocity(.init())
            shootable.entityPhysicsComponent?.setAngularVelocity(0)
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        guard let game = game else {
            return
        }
        
        for _ in game.shootables {
            print("moving")
        }
    }
    
    override func keyDown(event: NSEvent) {
        print(5)
        
        switch event.keyCode {
        case 15:
            resetVelocities()
            game?.returnShootables()
            stateMachine?.enter(RetryState.self)
            return
        default: return
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let game = game else {
            return
        }
        
        for shootable in game.shootables {
            guard let ballBody = shootable.entityPhysicsComponent?.physicsBody else {
                continue
            }
            if !ballBody.isResting {
                return
            }
            stateMachine?.enter(ReadyState.self)
        }
    }

}

