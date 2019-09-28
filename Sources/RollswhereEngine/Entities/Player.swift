import GameplayKit

extension SKPhysicsBody {
    
    var isResting: Bool {
        let v = hypot(velocity.dx, velocity.dy)
        return abs(v) < 1 && allContactedBodies().count > 0
    }
    
}

public class Player: GKEntity, GameComponentCollectionProtocol {
    
    var playerControl: PlayerControlComponent? {
        return components.filter{ $0 is PlayerControlComponent }.map{ $0 as! PlayerControlComponent }.first
    }
    
    var shootables: [Shootable] {
        guard let game = game else {
            return []
        }
        return game.shootables.filter{ $0.player == self }
    }
        
    var draggables: [DragComponent] {
        guard let game = game else {
            return []
        }
        return game.draggables.filter{ $0.player == self }
    }
    
    var rotations: [RotateComponent] {
        guard let game = game else {
            return []
        }
        return game.rotations.filter{ $0.player == self }
    }
    
    var starts: [StartComponent] {
        guard let game = game else {
            return []
        }
        return game.starts.filter{ $0.player == self }
    }
    
    var finishes: [FinishComponent] {
        guard let game = game else {
            return []
        }
        return game.finishes.filter{ $0.player == self }
    }
        
    var nodeComponent: GKSKNodeComponent? {
        return self.components.filter{ $0 is GKSKNodeComponent }.first as? GKSKNodeComponent
    }
    
    var game: Game?
    
    public override init() {
        super.init()
    }
    
    public convenience init(game: Game) {
        
        self.init()
        
        self.game = game
                
        print(shootables)
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
