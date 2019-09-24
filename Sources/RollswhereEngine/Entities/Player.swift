import GameplayKit

public class Player: GKEntity {
    
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
        
        self.stateMachine = GameStateMachine(game: game, states: [
            EnterLevelState(),
            RetryState(),
            ReadyState(),
            MovingState()
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
