import GameplayKit

extension SKPhysicsBody {
    
    var isResting: Bool {
        let v = hypot(velocity.dx, velocity.dy)
        return abs(v) < 1 && allContactedBodies().count > 0
    }
    
}

public class Player: GKEntity, GameComponentCollectionProtocol {
    
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
    
    var stateMachine: GameStateMachine?
    
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
        
        self.stateMachine = GameStateMachine(game: game, player: self, states: [
            EnterLevelState(),
            RetryState(),
            ReadyState(),
            MovingState()
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        
        for shootable in shootables {
            shootable.panGestureHandler(gestureRecognizer, stateMachine)
        }

        for draggable in draggables {
            draggable.panGestureHandler(gestureRecognizer)
        }

//        for rotation in game?.rotations ?? [] {
//            rotation.panGestureHandler(gestureRecognizer)
//        }
        
    }
    
    func resetVelocities() {
        for shootable in shootables {
            shootable.entityPhysicsComponent?.setVelocity(.init())
            shootable.entityPhysicsComponent?.setAngularVelocity(0)
        }
    }
        
    func enterReadyIfRested() {
        guard !self.shootables.isEmpty else {
            return
        }
        for shootable in self.shootables {
            guard let physicsbody = shootable.entityPhysicsComponent?.physicsBody else {
                continue
            }
            print(physicsbody.velocity)
            if !physicsbody.isResting {
                return
            }
        }
        self.stateMachine?.enter(ReadyState.self)
    }
    
    func returnShootables() {
        var i = 0
        for shootable in shootables {
            guard let returnPos = starts[i % starts.count].entityNodeComponent?.node.position else {
                return
            }
            shootable.entityNodeComponent?.node.position = returnPos
            i += 1
        }
    }
    
    func returnIfSpecifiedKeyPressed(event: NSEvent) {
        switch event.keyCode {
        case 15:
            resetVelocities()
            returnShootables()
            stateMachine?.enter(RetryState.self)
            return
        default: return
        }
    }
    
}
