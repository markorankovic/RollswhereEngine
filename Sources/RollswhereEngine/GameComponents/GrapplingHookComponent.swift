import SpriteKit

open class GrapplingHookComponent: GameComponent {
    
    var originalParentNode: SKNode?
    
    var fired = false
        
    let rope = SKShapeNode()
    
    func fire() {
        guard let node = nodeComponent?.node else {
            return
        }
        print("Hook fired")
        separateFromNode()
        addPhysics()
        fired = true
        let speed: CGFloat = 5000
        physicsComponent?.setVelocity(CGVector(dx: CGFloat(speed * cos(node.zRotation)), dy: CGFloat(speed * sin(node.zRotation))))
        node.scene?.addChild(rope)
    }
                
    func initializeRope() {
        guard let node = nodeComponent?.node else {
            return
        }
        guard let originalParentNode = originalParentNode else {
            return
        }
        guard let scene = originalParentNode.scene else {
            return
        }
        let physicsWorld = scene.physicsWorld
        let joint = SKPhysicsJointLimit.joint(
            withBodyA: originalParentNode.physicsBody!,
            bodyB: node.physicsBody!,
            anchorA: originalParentNode.position,
            anchorB: node.position
        )
        joint.maxLength = node.position.distanceFrom(originalParentNode.position)
        physicsWorld.add(joint)
    }
    
    func returnToNode() {
        guard let node = nodeComponent?.node else {
            return
        }
        guard let originalParentNode = originalParentNode else {
            return
        }
        node.physicsBody = nil
        node.removeFromParent()
        originalParentNode.addChild(node)
        node.position = .init()
        node.zRotation = 0
    }
    
    func separateFromNode() {
        guard let node = nodeComponent?.node else {
            return
        }
        guard let parentNode = nodeComponent?.node.parent else {
            return
        }
        guard let scene = node.scene else {
            return
        }
        let p = scene.convert(node.position, from: parentNode)
        node.removeFromParent()
        scene.addChild(node)
        node.position = p
        node.zRotation = parentNode.zRotation
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
        guard let originalParentNode = originalParentNode else {
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
