import GameplayKit
import Smorgasbord

open class Shootable: GameComponent {
            
    var power: CGFloat = 0
    
    var clickedLocation: CGPoint?
    
    var entityPhysicsComponent: PhysicsComponent? {
        return entity?.components.filter{ $0 is PhysicsComponent }.first as? PhysicsComponent
    }
    
    var entityNodeComponent: GKSKNodeComponent? {
        return entity?.components.filter{ $0 is GKSKNodeComponent }.first as? GKSKNodeComponent
    }
        
    func activate(_ loc: CGPoint) {
        self.clickedLocation = loc
    }
    
    func deactivate() {
        clickedLocation = nil
    }
    
    func setPower(_ to: CGFloat) {
        power = to
    }
    
    func increasePower(_ by: CGFloat) {
        setPower(power + by)
    }
    
    func shoot() {
        guard let scene = entityNodeComponent?.node.scene as? GameScene else {
            return
        }
        entityPhysicsComponent?.setVelocity(.init(dx: power, dy: 0))
        entityPhysicsComponent?.toggleGravity(on: true)
        setPower(0)
        scene.state?.stateMachine?.enter(MovingState.self)
    }
    
    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        evaluate(gestureRecognizer)
    }
    
    func evaluate(_ gestureRecognizer: NSPanGestureRecognizer) {
        guard let scene = entityNodeComponent?.node.scene as? GameScene else {
            return
        }
                        
        guard let node = entityNodeComponent?.node else {
            return
        }
                        
        let loc = scene.convertPoint(fromView: gestureRecognizer.location(in: scene.view as? GameView))
        
        switch gestureRecognizer.state {
        case .began:
            if clickedOn(clickLocation: loc, scene: scene) {
                activate(loc)
            }
            break
        case .ended:
            deactivate()
            if power > 50 {
                shoot()
                return
            }
            break
        default:
            if clickedLocation != nil {
                let vectorDistance = loc - node.position
                let distance = hypot(vectorDistance.x, vectorDistance.y)
                let power = distance * 10
                setPower(power)
                print(power)
            }
        }
    }
    
    func clickedOn(clickLocation loc: CGPoint, scene: GameScene) -> Bool {
        guard let visualnode = entityNodeComponent?.node else {
            return false
        }
        return scene.nodes(at: loc).contains(visualnode)
    }
    
}
