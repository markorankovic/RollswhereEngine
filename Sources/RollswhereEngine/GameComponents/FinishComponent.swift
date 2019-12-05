import SpriteKit
import GameplayKit

open class FinishComponent: GameComponent {
        
    public override init() {
        super.init()
    }

    public required init?(coder: NSCoder) { super.init() }
    
    func inContactWithTrigger(shootable: ShootableComponent) -> Bool {
        guard let physicsBody = shootable.physicsComponent?.physicsBody else {
            return false
        }
        guard let triggerNode = nodeComponent?.node.childNode(withName: "exitTrigger") else {
            return false
        }
        return triggerNode.physicsBody?.allContactedBodies().contains(physicsBody) ?? false
    }
    
}
