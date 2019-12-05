import GameplayKit

class TransitionState: GameState {
    
    override func didEnter(from previousState: GKState?) {
        print("Transitioning to next level")
        game?.enterNextLevel()
    }
    
}
