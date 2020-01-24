import GameplayKit

class PlayingState: GameState {
    
    override func didEnter(from previousState: GKState?) {
        print("PlayingState Entered.")
        guard let players = game?.players else { return }
        for player in players {
            player.component(ofType: PlayerControlComponent.self)?.initShootableStates()
        }
    }
    
    override func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        guard let players = game?.players else { return }
        for player in players {
            var notReadyToMove = true
            for shootable in player.shootables {
                if shootable.stateMachine!.currentState is MovingState {
                    notReadyToMove = false
                }
                (shootable.stateMachine?.currentState as? GameState)?.panGestureHandler(gestureRecognizer)
            }
            guard notReadyToMove else {
                continue
            }
            for dragComponent in player.each(ofType: DraggableComponent.self) {
                dragComponent.panGestureHandler(gestureRecognizer, player)
                dragComponent.physicsComponent?.physicsBody?.categoryBitMask = moveableBlock
                dragComponent.actFixedForHoldingShootables(player.shootables)
            }
            for rotateComponent in player.each(ofType: RotateableComponent.self) {
                rotateComponent.panGestureHandler(gestureRecognizer)
            }
        }
    }
    
    override func mouseMoved(event: NSEvent) {
        guard let players = game?.players else { return }
        for player in players {
            for shootable in player.shootables {
                (shootable.stateMachine?.currentState as? GameState)?.mouseMoved(event: event)
            }
        }
    }
    
    override func keyDown(event: NSEvent) {
        guard let players = game?.players else { return }
        for player in players {
            for shootable in player.shootables {
                (shootable.stateMachine?.currentState as? GameState)?.keyDown(event: event)
            }
            for rotateComponent in player.each(ofType: RotateableComponent.self) {
                rotateComponent.keyDown(event: event)
            }
        }
    }
    
    override func keyUp(event: NSEvent) {
        guard let players = game?.players else { return }
        for player in players {
            for rotateComponent in player.each(ofType: RotateableComponent.self) {
                rotateComponent.keyUp(event: event)
            }
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        guard let players = game?.players else { return }
        for player in players {
            for shootable in player.shootables {
                shootable.stateMachine?.update(deltaTime: seconds)
                if shootable.exitedscene {
                    shootable.stateMachine?.enter(MovingState.self)
                }
            }
        }
    }
    
}
