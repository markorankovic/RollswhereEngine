import SpriteKit
import GameplayKit

open class ActivatorComponent: ReactToHitComponent {
    
    override var nodeComponent: GKSKNodeComponent? {
        return entity?.components.filter{ $0 is GKSKNodeComponent }.first as? GKSKNodeComponent
    }

    override var objectHit: Bool {
        return getContactedPhysics().count > 0
    }
    
    override func getContactedPhysics() -> [SKPhysicsBody] {
        guard let buttonPhysics = nodeComponent?.node.childNode(withName: "button")?.physicsBody else {
            return []
        }
        return buttonPhysics.allContactedBodies()
    }

    override func evaluate() {
        for _ in getContactedPhysics() {
            guard let activated = nodeComponent?.node.childNode(withName: "activated") else {
                return
            }
            for node in activated.children {
                let a = SKAction(named: "antirotate")
                node.run(a!)
            }
        }
    }
    
}
