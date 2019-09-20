import GameplayKit

extension SKPhysicsBody {
    
    var isResting: Bool {
        let v = hypot(velocity.dx, velocity.dy)
        return abs(v) < 1 && allContactedBodies().count > 0
    }
    
}

class RetryState: GameState {
    
    
    override func didEnter(from previousState: GKState?) {
        if let previousState = previousState {
            if previousState is EnterLevelState {
                print("Getting ready to shoot")
            } else {
                print("Retrying attempt")
            }
        }
    }
        
    override func update(deltaTime seconds: TimeInterval) {
                        
        guard let game = game else {
            return
        }
        DispatchQueue.main.async {
            for shootable in game.shootables {
                guard let physicsbody = shootable.entityPhysicsComponent?.physicsBody else {
                        continue
                }
                if !physicsbody.isResting {
                    return
                }
            }
            self.stateMachine?.enter(ReadyState.self)
        }
    }

}
