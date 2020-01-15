import SpriteKit
import GameplayKit

open class GameComponent: GKComponent {
    var player: Player?
    var physicsComponent: PhysicsComponent? {
        entity?.component(ofType: PhysicsComponent.self)
    }
    var nodeComponent: GKSKNodeComponent? {
        entity?.component(ofType: GKSKNodeComponent.self)
    }
    public override init() {
        super.init()
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
