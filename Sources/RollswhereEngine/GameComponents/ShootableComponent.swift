import GameplayKit
import Smorgasbord

open class ShootableComponent: GameComponent {
            
    var power: CGFloat = 0
    var clickedLocation: CGPoint?
    var stateMachine: GameStateMachine?
    
    func deactivateCollisionWithDynamics() {
        //physicsComponent.setCategoryBitMask(0)
    }
    
    var game: Game? {
        return (nodeComponent?.node.scene as? GameScene)?.game
    }
            
    var physicsComponent: PhysicsComponent? {
        return entity?.components.filter{ $0 is PhysicsComponent }.first as? PhysicsComponent
    }
    
    override var nodeComponent: GKSKNodeComponent? {
        return entity?.components.filter{ $0 is GKSKNodeComponent }.first as? GKSKNodeComponent
    }
    
    public override init() {
        super.init()
        stateMachine = GameStateMachine(game: game, shootable: self, states: [
            EnterLevelState(),
            MovingState(),
            ReadyState(),
            RetryState()
        ])
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        stateMachine = GameStateMachine(game: game, shootable: self, states: [
            EnterLevelState(),
            MovingState(),
            ReadyState(),
            RetryState()
        ])
    }
    
    func activate(_ loc: CGPoint) { self.clickedLocation = loc }
    func deactivate() { clickedLocation = nil}
    func setPower(_ to: CGFloat) { power = to }
    func increasePower(_ by: CGFloat) { setPower(power + by) }
    
    func shoot(_ stateMachine: GKStateMachine?) {
        physicsComponent?.setVelocity(.init(dx: power, dy: 0))
        physicsComponent?.toggleGravity(on: true)
        setPower(0)
        stateMachine?.enter(MovingState.self)
    }
    
    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        evaluate(gestureRecognizer)
    }
    
    func evaluate(_ gestureRecognizer: NSPanGestureRecognizer) {
        guard let scene = nodeComponent?.node.scene as? GameScene else {
            return
        }
                        
        guard let node = nodeComponent?.node else {
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
                shoot(stateMachine) 
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
        guard let visualnode = nodeComponent?.node else { return false }
        return scene.nodes(at: loc).contains(visualnode)
    }
    
    func returnIfSpecifiedKeyPressed(event: NSEvent) {
        switch event.keyCode {
            case 15:
                resetVelocity()
                stateMachine?.enter(RetryState.self)
                return
            default: return
        }
    }
    
    func resetVelocity() {
        physicsComponent?.setVelocity(.init())
        physicsComponent?.setAngularVelocity(0)
    }
    
    func keyDown(_ event: NSEvent) { returnIfSpecifiedKeyPressed(event: event) }
                    
    func enterReadyIfRested() {
        guard let physicsbody = physicsComponent?.physicsBody else { return }
        print(physicsbody.velocity)
        if !physicsbody.isResting { return }
        stateMachine?.enter(ReadyState.self)
    }
 
    func returnToStart() {
        guard let game = player?.game else { return }
        guard let scene = game.currentGameScene else { return }
        guard let startComponent = (game.each(StartComponent.self).filter{ $0.shootable == self }.first) else { return }
        guard let startNode = startComponent.nodeComponent?.node else { return }
        //guard let parentNode = startNode.parent else { return }
        let returnPos = scene.convert(.init(), from: startNode)
        nodeComponent?.node.position = returnPos
    }
        
}
