open class GrapplingHookComponent: GameComponent {
    
    func fire() {
        print("Hook fired")
        separateFromShootable()
        physicsComponent?.setVelocity(.init(dx: 100, dy: 0))
    }
    
    func separateFromShootable() {
        guard let node = nodeComponent?.node else {
            return
        }
        guard let scene = node.scene else {
            return
        }
        node.removeFromParent()
        scene.addChild(node)
    }
    
}
