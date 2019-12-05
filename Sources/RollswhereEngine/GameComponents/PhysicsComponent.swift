import SpriteKit
import GameplayKit

open class PhysicsComponent: GameComponent {
    public override init() {
        super.init()
    }

    public required init?(coder: NSCoder) { super.init() }
    
    func setCategoryBitMask(_ bitMask: Int) {
        physicsBody?.categoryBitMask = 0
    }
    
    var physicsBody: SKPhysicsBody? {
        return entity?.component(ofType: GKSKNodeComponent.self)?.node.physicsBody
    }
    
    var noContact: Bool {
        guard let physicsBody = physicsBody else { return false }
        return physicsBody.allContactedBodies().count == 0
    }
                    
    func stopMovement() {
        setVelocity(.init())
        setAngularVelocity(0)
        toggleGravity(on: false)
    }
    
    func toggleGravity(on: Bool) {
        physicsBody?.affectedByGravity = on
    }
    
    func setVelocity(_ v: CGVector) {
        physicsBody?.velocity = v
    }
    
    func setAngularVelocity(_ v: CGFloat) {
        physicsBody?.angularVelocity = v
    }
    
}
