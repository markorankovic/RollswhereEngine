import SpriteKit
import GameplayKit

open class StartComponent: GameComponent {
           
    var player: Player? 
    
    var entityPhysicsComponent: PhysicsComponent? {
        return entity?.components.filter{ $0 is PhysicsComponent }.first as? PhysicsComponent
    }
    
    var entityNodeComponent: GKSKNodeComponent? {
        return entity?.components.filter{ $0 is GKSKNodeComponent }.first as? GKSKNodeComponent
    }
    
}

