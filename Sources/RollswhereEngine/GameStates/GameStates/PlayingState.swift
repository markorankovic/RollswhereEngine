import GameplayKit

class PlayingState: GameState {
    
    override func didEnter(from previousState: GKState?) {
        
        guard let players = game?.players else {
            return
        }
        
        for player in players {
            player.stateMachine?.enter(EnterLevelState.self)
        }
        
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
            (player.stateMachine?.currentState as? GameState)?.update(deltaTime: seconds)
        }
        
    }
    
}
