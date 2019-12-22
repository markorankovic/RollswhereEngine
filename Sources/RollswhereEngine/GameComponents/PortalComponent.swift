import GameplayKit

open class PortalComponent: ReactToHitComponent {
    
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
        guard let entryNodePhysics = nodeComponent?.node.childNode(withName: "entry")?.physicsBody else {
            return []
        }
        return entryNodePhysics.allContactedBodies()
    }
    
    override func evaluate() {
        guard let exitNode = nodeComponent?.node.childNode(withName: "exit") else {
            return
        }
        guard let entryNode = nodeComponent?.node.childNode(withName: "entry") else {
            return
        }
        for physics in getContactedPhysics() {
            print(3)
            guard let collidingNode = physics.node else {
                continue
            }
            let distY = abs(
                entryNode.position.y - collidingNode.position.y
            )
            if distY > 30 {
                continue
            }
            physics.node?.position = exitNode.position
        }
    }
    
}
