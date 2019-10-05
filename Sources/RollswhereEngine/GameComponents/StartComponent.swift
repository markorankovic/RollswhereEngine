import SpriteKit
import GameplayKit

open class StartComponent: GameComponent {
               
    var entityPhysicsComponent: PhysicsComponent? {
        return entity?.components.filter{ $0 is PhysicsComponent }.first as? PhysicsComponent
    }
        
    var shootable: Shootable?
    
}

