import GameplayKit

class PlayingState: GameState {
    
    override func didEnter(from previousState: GKState?) {
        game?.startPlayers()
    }
    
    override func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        
        guard let players = game?.players else {
            return
        }
        
        for player in players {
            (player.stateMachine?.currentState as? GameState)?.panGestureHandler(gestureRecognizer)
        }

    }
        
    override func keyDown(event: NSEvent) {
print(5)
        guard let players = game?.players else {
            return
        }

        for player in players {
            (player.stateMachine?.currentState as? GameState)?.keyDown(event: event)
        }

    }

    override func update(deltaTime seconds: TimeInterval) {

        guard let players = game?.players else {
            return
        }
        
        for player in players {
            player.stateMachine?.update(deltaTime: seconds)
        }
        
    }
    
}
