import SpriteKit
import GameplayKit
//import Smorgasbord

open class DraggableComponent: GameComponent {
            
    public override init() {
        super.init()
    }
    
    public required init?(coder: NSCoder) { super.init() }
    
    var active = false
    
    func activate() {
        active = true
    }
    
    func deactivate() {
        active = false
    }
        
    override var physicsComponent: PhysicsComponent? {
        return entity?.components.filter{ $0 is PhysicsComponent }.first as? PhysicsComponent
    }
    
    var rotateComponent: RotateableComponent? {
        return entity?.components.filter{ $0 is RotateableComponent }.first as? RotateableComponent
    }
        
    func beingDragged(_ gestureRecognizer: NSPanGestureRecognizer) -> Bool {
        guard let node = nodeComponent?.node else { return false }
        guard let scene = node.scene else { return false }
        let location = gestureRecognizer.location(in: scene.view)
        return scene.nodes(at: scene.convertPoint(fromView: location)).contains(node)
    }
    
    func moveBy(_ gestureRecognizer: NSPanGestureRecognizer) {
        guard let scene = nodeComponent?.node.scene else { return }
        guard let node = nodeComponent?.node else { return }
        let loc = scene.convertPoint(fromView: gestureRecognizer.location(in: scene.view))
        node.position = loc
    }
    
    var rKeyDown = false
    
    func actFixedForHoldingShootables(_ shootables: [ShootableComponent]) {
        guard let draggableBody = physicsComponent?.physicsBody else {
            return
        }
        for shootable in shootables {
            guard let shootableBody = shootable.physicsComponent?.physicsBody else {
                return
            }
            if draggableBody.allContactedBodies().contains(shootableBody) {
                draggableBody.categoryBitMask = fixedBlock
            }
        }
    }
    
    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer, _ player: Player) {
        switch gestureRecognizer.state {
        case .began:
            if beingDragged(gestureRecognizer) {
                activate()
            }
            return
        case .ended:
            for shootable in player.shootables {
                shootable.activatePhysics()
            }
            deactivate()
            return
        default:
            var rotating = false
            if let rotateComponent = rotateComponent {
                rotating = rotateComponent.rotating
            }
            if active && !rotating {
                for shootable in player.shootables {
                    shootable.deactivatePhysics()
                }
                moveBy(gestureRecognizer)
            }
            return
        }
        
    }
    
}

extension GKSKNodeComponent {
    func moveBy(_ velocity: CGPoint, _ duration: TimeInterval) {
        let vector = CGVector(dx: velocity.x, dy: velocity.y)
        let action = SKAction.move(by: vector, duration: duration)
        node.run(action)
    }
}
