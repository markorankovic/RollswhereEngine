import SpriteKit

open class GrapplingHookComponent: GameComponent {
    
    var shootableNode: SKNode?
    
    var fired = false
        
    let rope = SKShapeNode()
    
    var attached: Bool {
        return shootableNode != nil
    }
    
    func fire() {
        guard let node = nodeComponent?.node else {
            return
        }
        print("Hook fired")
        nodeComponent?.node.constraints = []
        addPhysics()
        fired = true
        let speed: CGFloat = 5000
        physicsComponent?.setVelocity(CGVector(dx: CGFloat(speed * cos(node.zRotation)), dy: CGFloat(speed * sin(node.zRotation))))
        node.scene?.addChild(rope)
    }
    
    func mouseMoved(with event: NSEvent) {
        guard let node = nodeComponent?.node else {
            return
        }
        if attached {
            node.run(.rotate(byAngle: (event.deltaX > 0 ? 0.1 : -0.1), duration: 0.1))
        }
    }
    
    func attachTo(_ shootableComponent: ShootableComponent) {
        shootableNode = shootableComponent.nodeComponent?.node
        shootableComponent.hookComponent = self
        if let shootableNode = shootableNode {
            nodeComponent?.node.constraints = [
                SKConstraint.distance(.init(constantValue: 0), to: shootableNode)
            ]
            nodeComponent?.node.physicsBody = nil
            print("Hook attached")
        }
    }
    
    func contactsShootable(shootable: ShootableComponent) -> Bool {
        guard let physicsBody = nodeComponent?.node.physicsBody else {
            return false
        }
        guard let shootableBody = shootable.physicsComponent?.physicsBody else {
            return false
        }
        if shootableBody.allContactedBodies().contains(physicsBody) {
            return true
        }
        return false
    }
    
    func initializeRope() {
        guard let node = nodeComponent?.node else {
            return
        }
        guard let shootableNode = shootableNode else {
            return
        }
        guard let scene = shootableNode.scene else {
            return
        }
        let physicsWorld = scene.physicsWorld
        let joint = SKPhysicsJointLimit.joint(
            withBodyA: shootableNode.physicsBody!,
            bodyB: node.physicsBody!,
            anchorA: shootableNode.position,
            anchorB: node.position
        )
        joint.maxLength = node.position.distanceFrom(shootableNode.position)
        physicsWorld.add(joint)
    }
    
    func returnToNode() {
        guard let node = nodeComponent?.node else {
            return
        }
        guard let originalParentNode = shootableNode else {
            return
        }
        node.physicsBody = nil
        node.removeFromParent()
        originalParentNode.addChild(node)
        node.position = .init()
        node.zRotation = 0
    }
        
    func addPhysics() {
        guard let node = nodeComponent?.node else {
            return
        }
        let physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
        physicsBody.categoryBitMask = 0
        physicsBody.collisionBitMask = 0
        physicsBody.contactTestBitMask = 2
        node.physicsBody = physicsBody
        let physicsComponent = PhysicsComponent()
        entity?.addComponent(physicsComponent)
    }
    
    func drawRope() {
        guard let node = nodeComponent?.node else {
            return
        }
        guard let originalParentNode = shootableNode else {
            return
        }
        let ropePath: CGMutablePath = CGMutablePath()
        ropePath.addLines(between: [
            node.position,
            originalParentNode.position
        ])
        rope.path = ropePath
    }
    
    override open func update(deltaTime seconds: TimeInterval) {
        guard let physicsComponent = physicsComponent else {
            return
        }
        if !physicsComponent.noContact {
            physicsComponent.physicsBody?.isDynamic = false
            physicsComponent.physicsBody?.affectedByGravity = false
            physicsComponent.physicsBody?.pinned = true
            print("Hook contact")
            if fired {
                print("Rope deployed")
                initializeRope()
            }
        }
        drawRope()
    }
    
}
