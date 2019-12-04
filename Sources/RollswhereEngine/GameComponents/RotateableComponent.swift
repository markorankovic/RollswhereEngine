import Smorgasbord
import GameplayKit

open class RotateableComponent: GameComponent {
        
    var active = false
    var rKeyDown = false
    
    func activate() {active = true}
    func deactivate() { active = false }
        
    var physicsComponent: PhysicsComponent? {
        return entity?.components.filter{ $0 is PhysicsComponent }.first as? PhysicsComponent
    }
    
    var rotating = false
    
    public override init() {
        super.init()
    }

    public required init?(coder: NSCoder) { super.init() }
    
    func beingDragged(_ gestureRecognizer: NSPanGestureRecognizer) -> Bool {
        guard let node = nodeComponent?.node else { return false }
        guard let scene = node.scene else { return false }
        let location = gestureRecognizer.location(in: scene.view)
        return scene.nodes(at: scene.convertPoint(fromView: location)).contains(node)
    }
    
    func rotateBy(_ gestureRecognizer: NSPanGestureRecognizer) {
        guard let scene = nodeComponent?.node.scene else { return }
        let velocity = gestureRecognizer.velocity(in: scene.view) * 0.001
        nodeComponent?.rotateBy(velocity, 0.1)
    }
    
    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            if beingDragged(gestureRecognizer) {
                activate()
            }
            return
        case .ended:
            deactivate()
            print(arc4random())
            rKeyDown = false
            rotating = false
            return
        default:
            guard let physicsComponent = physicsComponent else {
                return
            }
            if active && rKeyDown && physicsComponent.noContact {
                rotateBy(gestureRecognizer)
                rotating = true
            }
        }
        
    }
    
    func keyDown(event: NSEvent) {
        if event.keyCode == 15 { rKeyDown = true }
    }
        
    func keyUp(event: NSEvent) {
        if event.keyCode == 15 {
            rKeyDown = false
            print("r key not down")
        }
    }
    
}

extension GKSKNodeComponent {
    func rotateBy(_ velocity: CGPoint, _ duration: TimeInterval) {
        let vector = CGVector(dx: velocity.x, dy: velocity.y)
        let action = SKAction.rotate(byAngle: vector.dx, duration: duration)
        node.run(action)
    }
}
