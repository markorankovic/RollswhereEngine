import GameplayKit

public class GameStateMachine: GKStateMachine {
    
    var game: Game? 
    var shootable: ShootableComponent?
    
    convenience init(game: Game?, shootable: ShootableComponent?, states: [GKState]) {
        self.init(states: states)
        self.shootable = shootable
        self.game = game
    }
    
}
