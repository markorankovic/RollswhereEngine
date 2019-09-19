import SpriteKit
import GameplayKit

open class Game: GameComponentCollectionProtocol {
    
    public init() {
        stateMachine = GKStateMachine(states: [
            EnterLevelState(game: self),
            RetryState(game: self),
            ReadyState(game: self),
            MovingState(game: self)
        ])
    }
    
    public var shootables: [Shootable] {
        guard let currentScene = currentScene else {
            return []
        }
        return currentScene.entities.filter{ !$0.components.filter{ $0 is Shootable }.isEmpty }.map{ $0.components.filter{ $0 is Shootable }.first as! Shootable }
    }
    
    public var draggables: [DragComponent] {
        guard let currentScene = currentScene else {
            return []
        }
        return currentScene.entities.filter{ !$0.components.filter{ $0 is DragComponent }.isEmpty }.map{ $0.components.filter{ $0 is DragComponent }.first as! DragComponent }
    }
    
    public var starts: [StartComponent] {
        guard let currentScene = currentScene else {
            return []
        }
        return currentScene.entities.filter{ !$0.components.filter{ $0 is StartComponent }.isEmpty }.map{ $0.components.filter{ $0 is StartComponent }.first as! StartComponent }
    }
    
    public var finishes: [FinishComponent] {
        guard let currentScene = currentScene else {
            return []
        }
        return currentScene.entities.filter{ !$0.components.filter{ $0 is FinishComponent }.isEmpty }.map{ $0.components.filter{ $0 is FinishComponent }.first as! FinishComponent }
    }
    
    public var rotations: [RotateComponent] {
        guard let currentScene = currentScene else {
            return []
        }
        return currentScene.entities.filter{ !$0.components.filter{ $0 is RotateComponent }.isEmpty }.map{ $0.components.filter{ $0 is RotateComponent }.first as! RotateComponent }
    }
    
    public var stateMachine: GKStateMachine?
        
    public weak var view: Presenter?
    
    public var currentScene: GKScene?
    
    public var currentGameScene: GameScene? {
        currentScene?.rootNode as? GameScene
    }
    
    func returnShootables() {
        for shootable in shootables {
            shootable.entityNodeComponent?.node.position = .init(x: -370, y: 160)
        }
    }
    
    open func runLevel(_ level: GKScene) {
        currentScene = level
        stateMachine?.enter(EnterLevelState.self)
        let scene = level.rootNode as? GameScene
        view?.presentScene(scene)
        print(scene)
    }
    
}

