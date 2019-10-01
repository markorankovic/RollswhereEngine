import GameplayKit

public class GameStateMachine: GKStateMachine {
    
    var game: Game? 
        
    var shootable: Shootable?
    
    convenience init(game: Game?, shootable: Shootable?, states: [GKState]) {
        self.init(states: states)
        self.shootable = shootable
        self.game = game
    }
    
}
