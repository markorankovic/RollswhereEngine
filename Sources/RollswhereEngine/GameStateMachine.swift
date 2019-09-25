import GameplayKit

public class GameStateMachine: GKStateMachine {
    
    var game: Game?
    
    var player: Player?
    
    convenience init(game: Game?, player: Player?, states: [GKState]) {
        self.init(states: states)
        self.game = game
        self.player = player
    }
    
}
