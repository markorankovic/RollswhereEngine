import GameplayKit

class PlayingState: GameState {
    
    override func didEnter(from previousState: GKState?) {
        print(game?.currentScene?.entities)
        guard let players = game?.players else {
            return
        }
        
        for player in players {
            player.playerControl?.initShootableStates()
        }
        
        print("PlayingState Entered.")
    }
    
    override func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        
        guard let players = game?.players else {
            return
        }
        
        for player in players {
            player.playerControl?.panGestureHandler(gestureRecognizer)
        }

    }
        
    override func keyDown(event: NSEvent) {
        
        guard let players = game?.players else {
            return
        }
                
        for player in players {
            player.playerControl?.keyDown(event)
        }

    }
    
    override func keyUp(event: NSEvent) {
        
        guard let players = game?.players else {
            return
        }
                
        for player in players {
            player.playerControl?.keyUp(event)
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
