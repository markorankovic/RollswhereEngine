import GameplayKit

class PlayingState: GameState {
    
    override func didEnter(from previousState: GKState?) {
        guard let players = game?.players else {
            return
        }
        
        for player in players {
            player.component(ofType: PlayerControlComponent.self)?.initShootableStates()
        }
        
        print("PlayingState Entered.")
    }
    
    override func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        
        guard let players = game?.players else {
            return
        }
        
        for player in players {
            player.component(ofType: PlayerControlComponent.self)?.panGestureHandler(gestureRecognizer)
        }

    }
        
    override func keyDown(event: NSEvent) {
        
        guard let players = game?.players else {
            return
        }
                
        for player in players {
            player.component(ofType: PlayerControlComponent.self)?.keyDown(event)
        }

    }
    
    override func keyUp(event: NSEvent) {
        
        guard let players = game?.players else {
            return
        }
                
        for player in players {
            player.component(ofType: PlayerControlComponent.self)?.keyUp(event)
        }

    }

    override func update(deltaTime seconds: TimeInterval) {
        
        guard let players = game?.players else {
            return
        }
        
        for player in players {
            player.update(deltaTime: seconds)
        }
        
    }
    
}
