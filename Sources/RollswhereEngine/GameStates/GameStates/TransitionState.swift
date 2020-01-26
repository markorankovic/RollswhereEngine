import GameplayKit

class TransitionState: GameState {
    
    override func didEnter(from previousState: GKState?) {
        print("Transitioning to next level")
        if let game = game as? VisualGame {
            game.enterNextLevel()
        }
    }
    
}
