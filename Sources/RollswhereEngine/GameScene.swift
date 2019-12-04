import SpriteKit
import GameplayKit

open class GameScene: SKScene {
    override init() {
        super.init()
        if name == "gksceneinitoutoforder" {
            print("GKScene initializer is out of order")
            addEntitiesToChildren()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addEntitiesToChildren() {
        for node in children {
            guard let nodeValues = node.userData?.allValues.compactMap({ $0 as? String }) else {
                continue
            }
            var components: [GKComponent] = []
            for nodeValue in nodeValues {
                switch nodeValue {
                case "physics": components.append(PhysicsComponent())
                case "shootable": components.append(ShootableComponent())
                case "draggable": components.append(DraggableComponent())
                case "rotatable": components.append(RotateableComponent())
                case "playercontrol": components.append(PlayerControlComponent())
                default: break
                }
            }
            if !components.isEmpty {
                print("entity")
                let entity = GKEntity()
                entity.addComponent(GKSKNodeComponent(node: node))
                for component in components {
                    entity.addComponent(component)
                }
                node.entity = entity
                print("components: \(entity.components)")
                print()
            }
        }
    }
    open override func didMove(to view: SKView) {
        physicsWorld.speed = 1
        anchorPoint = .init(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
    }
    public var game: Game? {
        if let g = (view as? GameView)?.game {
            return g
        } else {
            return nil
        }
    }
    var state: GameState? { return game?.stateMachine?.currentState as? GameState }
    override public func keyDown(with event: NSEvent) { state?.keyDown(event: event) }
    override public func keyUp(with event: NSEvent) {
        state?.keyUp(event: event)
        print("key released")
    }
    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        state?.panGestureHandler(gestureRecognizer)
    }
    override public func update(_ currentTime: TimeInterval) { state?.update(deltaTime: currentTime) }
}
