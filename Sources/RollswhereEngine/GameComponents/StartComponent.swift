import SpriteKit
import GameplayKit

open class StartComponent: GameComponent {
               
    var physicsComponent: PhysicsComponent? {
        return entity?.components.filter{ $0 is PhysicsComponent }.first as? PhysicsComponent
    }
    
    override var nodeComponent: GKSKNodeComponent? {
        return entity?.components.filter{ $0 is GKSKNodeComponent }.first as? GKSKNodeComponent
    }
        
    var shootable: ShootableComponent?
    
    public override init() {
        super.init()
    }

    public required init?(coder: NSCoder) { super.init() }
    
}

