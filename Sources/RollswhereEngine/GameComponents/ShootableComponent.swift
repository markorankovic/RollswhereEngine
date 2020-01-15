import GameplayKit
//import Smorgasbord

open class ShootableComponent: GameComponent {
            
    var power: CGFloat = 0
    let maxPower: CGFloat = 10000
    var clickedLocation: CGPoint?
    var stateMachine: GameStateMachine?
        
    var game: Game? {
        return stateMachine?.game
    }
            
    override var physicsComponent: PhysicsComponent? {
        return entity?.components.filter{ $0 is PhysicsComponent }.first as? PhysicsComponent
    }
    
    override var nodeComponent: GKSKNodeComponent? {
        return entity?.components.filter{ $0 is GKSKNodeComponent }.first as? GKSKNodeComponent
    }
    
    var hookComponent: GrapplingHookComponent? {
        return entity?.components.filter{ $0 is GrapplingHookComponent }.first as? GrapplingHookComponent
    }
    
    var active = false

    func activatePhysics() {
        physicsComponent?.physicsBody?.categoryBitMask = 0
        physicsComponent?.physicsBody?.collisionBitMask = fixedBlock | moveableBlock
        physicsComponent?.physicsBody?.contactTestBitMask = fixedBlock | moveableBlock | react
        active = true
        print("Physics activated")
    }
    
    func deactivatePhysics() {
        physicsComponent?.physicsBody?.categoryBitMask = 0
        physicsComponent?.physicsBody?.collisionBitMask = fixedBlock
        physicsComponent?.physicsBody?.contactTestBitMask = fixedBlock
        active = false
        print("Physics deactivated")
    }
    
    func updateVisibility() {
        if !active {
            nodeComponent?.node.alpha = 0.5
        } else {
            nodeComponent?.node.alpha = 1
        }
    }
    
    func updatePowerDisplay() {
        guard let node = nodeComponent?.node else {
            return
        }
        node.childNode(withName: "powerbar")?.removeFromParent()
        guard let powerBar = createPowerBar(deltaAngle: power * (2 * .pi) / maxPower) else {
            return
        }
        node.addChild(powerBar)
    }
    
    func removePowerDisplay() {
        nodeComponent?.node.childNode(withName: "powerbar")?.removeFromParent()
    }
    
    private func createArc(radius: CGFloat, deltaAngle: CGFloat) -> CGMutablePath {
        let arcPath = CGMutablePath()
        arcPath.addRelativeArc(center: .init(), radius: radius, startAngle: .pi/2, delta: -(deltaAngle < 2 * .pi ? deltaAngle : 2 * .pi))
        return arcPath
    }

    private func createPowerBar(deltaAngle: CGFloat) -> SKShapeNode? {
        guard let node = nodeComponent?.node else {
            return nil
        }
        let powerBar = SKShapeNode()
        powerBar.path = createArc(
            radius: node.calculateAccumulatedFrame().width / 2,
            deltaAngle: deltaAngle
        )
        powerBar.strokeColor = .yellow
        powerBar.lineWidth = 2
        powerBar.zPosition = 10
        powerBar.name = "powerbar"
        return powerBar
    }
    
    public override init() {
        super.init()
        stateMachine = GameStateMachine(game: game, shootable: self, states: [
            EnterLevelState(),
            MovingState(),
            ReadyState(),
            RetryState()
        ])
        physicsComponent?.physicsBody?.linearDamping = 1
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
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
    
    func resetRotation() {
        nodeComponent?.node.zRotation = 0
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
            removePowerDisplay()
            if power > 50 {
                shoot(stateMachine) 
                return
            }
            break
        default:
            if clickedLocation != nil {
                let vectorDistance = loc - node.position
                let distance = hypot(vectorDistance.x, vectorDistance.y)
                let power = ((distance - 50) < 0 ? 0 : distance - 50) * 20
                setPower(power > maxPower ? maxPower : power)
                updatePowerDisplay()
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
    
    func keyDown(_ event: NSEvent) {
        returnIfSpecifiedKeyPressed(event: event)
        print(event.keyCode)
        if event.keyCode == 5 {
            print(hookComponent)
            hookComponent?.fire()
        }
    }
    
    func evaluateRest() {
        guard let physicsbody = physicsComponent?.physicsBody else { return }
        if physicsbody.resting && physicsbody.allContactedBodies().count > 0 {
            self.stateMachine?.enter(ReadyState.self)
        }
    }
    
    func enterReadyIfRested() {
        evaluateRest()
    }
    
}

extension SKPhysicsBody {
    var resting: Bool {
        let speed: CGFloat = 0.01
        return abs(velocity.dx) < speed && abs(velocity.dy) < speed
    }
}





