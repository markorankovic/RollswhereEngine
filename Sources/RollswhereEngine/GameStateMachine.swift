import GameplayKit

public class GameStateMachine: GKStateMachine {
    
    var game: Game? 
    
    var shootable: Shootable?
    
    var player: Player? {
        return shootable?.player
    }
    
    convenience init(shootable: Shootable?, states: [GKState]) {
        self.init(states: states)
        self.shootable = shootable
    }
    
}
