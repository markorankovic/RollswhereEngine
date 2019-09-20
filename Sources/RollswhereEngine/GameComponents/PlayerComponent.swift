

import GameplayKit
import SpriteKit

open class PlayerComponent: GameComponent {
    
    public var stateMachine: GKStateMachine?
    
    var entityPhysicsComponent: PhysicsComponent? {
        return entity?.components.filter{ $0 is PhysicsComponent }.first as? PhysicsComponent
    }
    
    var entityNodeComponent: GKSKNodeComponent? {
        return entity?.components.filter{ $0 is GKSKNodeComponent }.first as? GKSKNodeComponent
    }
    
    var game: Game? {
        return (stateMachine?.currentState as? GameState)?.game
    }
        
}
