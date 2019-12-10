import GameplayKit

extension SKPhysicsBody {
    
    var isResting: Bool {
        let v = hypot(velocity.dx, velocity.dy)
        return abs(v) < 1 && allContactedBodies().count > 0
    }
    
}

public class Player: GKEntity {
    
    public func each<Component: GameComponent>(ofType: Component.Type) -> [Component] {
        let componentsOfType = game?.each(ofType) ?? []
        return componentsOfType.filter{ $0.player == self }
    }
     
    var shootables: [ShootableComponent] {
        guard let shootables = game?.each(ShootableComponent.self) else {
            return []
        }
        return shootables.filter{ $0.player == self }
    }
    
    var nodeComponent: GKSKNodeComponent? {
        return self.components.filter{ $0 is GKSKNodeComponent }.first as? GKSKNodeComponent
    }
    
    var game: Game?
    
    public override init() {
        super.init()
        let playerComp = PlayerControlComponent()
        playerComp.player = self
        addComponent(playerComp)
    }
    
    public convenience init(game: Game) {
        self.init()
        self.game = game
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}
