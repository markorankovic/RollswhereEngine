import GameplayKit

open class PlayerControlComponent: GameComponent {
    public override init() {
        super.init()
    }

    public required init?(coder: NSCoder) { super.init() }
    
    func initShootableStates() {
        guard let player = player else { return }
        for shootable in player.shootables {
            shootable.stateMachine?.enter(RetryState.self)
        }
    }

    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        guard let player = player else { return }
        for draggable in player.each(ofType: DraggableComponent.self) {
            draggable.panGestureHandler(gestureRecognizer)
        }
        for rotation in player.each(ofType: RotateableComponent.self) {
            rotation.panGestureHandler(gestureRecognizer)
        }
    }
    
    func keyDown(_ event: NSEvent) {
        guard let player = player else { return }
        for rotation in player.each(ofType: RotateableComponent.self) {
            rotation.keyDown(event: event)
        }
    }
    
    func keyUp(_ event: NSEvent) {
        guard let player = player else { return }
        for rotation in player.each(ofType: RotateableComponent.self) {
            rotation.keyUp(event: event)
        }
    }
        
}
