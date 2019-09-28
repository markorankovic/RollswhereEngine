import GameplayKit

open class PlayerControlComponent: GameComponent {
        
    var player: Player? {
        return entity as? Player
    }
    
    func initShootableStates() {
        
        guard let player = player else {
            return
        }
        
        for shootable in player.shootables {
            print(shootable.stateMachine)
            shootable.stateMachine?.enter(EnterLevelState.self)
        }
        
    }

    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        
        guard let player = player else {
            return
        }
        
        for draggable in player.draggables {
            draggable.panGestureHandler(gestureRecognizer)
        }

        for rotation in player.rotations {
            rotation.panGestureHandler(gestureRecognizer)
        }
        
    }
    
    func keyDown(_ event: NSEvent) {
        
        guard let player = player else {
            return
        }

        for rotation in player.rotations {
            rotation.keyDown(event: event)
        }
        
    }
    
    func keyUp(_ event: NSEvent) {
        
        guard let player = player else {
            return
        }

        for rotation in player.rotations {
            rotation.keyUp(event: event)
        }
        
    }
    
    var i = 0

    func returnToStart(shootable: Shootable) {
        
        guard let player = player else {
            return
        }

        guard player.starts.count > 0 else {
            return
        }
        
        guard let returnPos = player.starts[i % (player.starts.count)].entityNodeComponent?.node.position else {
            return
        }
        
        shootable.entityNodeComponent?.node.position = returnPos
        i += 1
        
    }

}
