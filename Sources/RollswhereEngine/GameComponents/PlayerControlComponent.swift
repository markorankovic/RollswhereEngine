import GameplayKit

open class PlayerControlComponent: GameComponent {
        
    override var player: Player? {
        set{}
        get{
            return entity as? Player
        }
    }
    
    func initShootableStates() {
        
        guard let player = player else {
            return
        }
        
        for shootable in player.each(ofType: Shootable.self) {
            shootable.stateMachine?.enter(EnterLevelState.self)
        }
        
    }

    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        
        guard let player = player else {
            return
        }
        
        for draggable in player.each(ofType: DragComponent.self) {
            draggable.panGestureHandler(gestureRecognizer)
        }

        for rotation in player.each(ofType: RotateComponent.self) {
            rotation.panGestureHandler(gestureRecognizer)
        }
        
    }
    
    func keyDown(_ event: NSEvent) {
        
        guard let player = player else {
            return
        }

        for rotation in player.each(ofType: RotateComponent.self) {
            rotation.keyDown(event: event)
        }
        
    }
    
    func keyUp(_ event: NSEvent) {
        
        guard let player = player else {
            return
        }

        for rotation in player.each(ofType: RotateComponent.self) {
            rotation.keyUp(event: event)
        }
        
    }
    
    var i = 0

    func returnToStart(shootable: Shootable) {
        
        guard let player = player else {
            return
        }

        let startComponents = player.each(ofType: StartComponent.self)
        
        guard startComponents.count > 0 else {
            return
        }
        
        guard let returnPos = startComponents[i % (startComponents.count)].entityNodeComponent?.node.position else {
            return
        }
        
        shootable.entityNodeComponent?.node.position = returnPos
        i += 1
        
    }

}
