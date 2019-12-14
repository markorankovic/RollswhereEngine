import GameplayKit

open class SpeedBoostComponent: ReactToHitComponent {
    
    public override init() {
        super.init()
    }
        
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var nodeComponent: GKSKNodeComponent? {
        return entity?.components.filter{ $0 is GKSKNodeComponent }.first as? GKSKNodeComponent
    }
    
    override var objectHit: Bool {
        return getContactedPhysics().count > 0
    }
    
    override func getContactedPhysics() -> [SKPhysicsBody] {
        return nodeComponent?.node.physicsBody?.allContactedBodies() ?? []
    }
    
    override func evaluate() {
        guard let node = nodeComponent?.node else {
            return
        }
        for physics in getContactedPhysics() {
            guard let collidingNode = physics.node else {
                continue
            }
            let distY = abs(
                node.position.x - collidingNode.position.y
            )
            if distY > 30 {
                continue
            }
            let speed = 2000
            physics.velocity = CGVector(dx: speed * Int(cos(node.zRotation)), dy: speed * Int(sin(node.zRotation)))
        }
    }
    
}
