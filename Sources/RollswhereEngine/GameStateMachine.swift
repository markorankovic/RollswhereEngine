import GameplayKit

public class GameStateMachine: GKStateMachine {
    
    var game: Game? {
        shootable?.game
    }
    
    var shootable: Shootable?
    
    convenience init(shootable: Shootable?, states: [GKState]) {
        self.init(states: states)
        self.shootable = shootable
    }
    
}
