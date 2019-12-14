import GameplayKit

open class ReactToHitComponent: GameComponent {
            
    var objectHit: Bool {
        return getContactedPhysics().count > 0
    }
    
    func getContactedPhysics() -> [SKPhysicsBody] {
        return []
    }
    
    func evaluate() { }
    
}
