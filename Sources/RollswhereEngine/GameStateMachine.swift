import GameplayKit

public class GameStateMachine: GKStateMachine {
    
    var game: Game?
    
    convenience init(game: Game?, states: [GKState]) {
        self.init(states: states)
        self.game = game
    }
    
}
