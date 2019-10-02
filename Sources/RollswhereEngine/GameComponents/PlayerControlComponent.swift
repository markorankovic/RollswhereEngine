import GameplayKit

open class PlayerControlComponent: GameComponent {
                    
    func initShootableStates() {
        guard let player = player else { return }
        for shootable in player.shootables {
            shootable.stateMachine?.enter(EnterLevelState.self)
        }
    }

    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        guard let player = player else { return }
        for draggable in player.each(ofType: DragComponent.self) {
            draggable.panGestureHandler(gestureRecognizer)
        }
        for rotation in player.each(ofType: RotateComponent.self) {
            rotation.panGestureHandler(gestureRecognizer)
        }
    }
    
    func keyDown(_ event: NSEvent) {
        guard let player = player else { return }
        for rotation in player.each(ofType: RotateComponent.self) {
            rotation.keyDown(event: event)
        }
    }
    
    func keyUp(_ event: NSEvent) {
        guard let player = player else { return }
        for rotation in player.each(ofType: RotateComponent.self) {
            rotation.keyUp(event: event)
        }
    }
        
}
