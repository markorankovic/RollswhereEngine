import SpriteKit
import GameplayKit

open class Game: GameComponentCollectionProtocol {
    
    public init() {
        stateMachine = GameStateMachine(game: self, player: nil, states: [
            MainMenuState(),
            PlayingState()
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
    
    public var stateMachine: GameStateMachine?
         
    public weak var view: Presenter?
    
    public var currentScene: GKScene?
    
    public var currentGameScene: GameScene? {
        currentScene?.rootNode as? GameScene
    }
                
    var players: [Player] {
        guard let level = currentScene else {
            return []
        }
        return level.entities.filter{ $0 is Player }.map{ $0 as! Player }
    }
    
    func replaceGKEntitiesAsPlayers(level: GKScene) {
        for entity in level.entities {
            if (entity.component(ofType: GKSKNodeComponent.self)?.node as? PlayerNode) != nil {
                let player = Player(game: self)
                for comp in entity.components {
                    player.addComponent(comp)
                }
                level.removeEntity(entity)
                level.addEntity(player)
            }
        }
    }
    
    open func runLevel(_ level: GKScene) {
        replaceGKEntitiesAsPlayers(level: level)
        currentScene = level
        let scene = level.rootNode as? GameScene
        assignStarts()
        assignDraggablesAndRotations()
        stateMachine?.enter(PlayingState.self)
        view?.presentScene(scene)
    }
    
    func assignStarts() {
        var i = 0
        for start in starts {
            start.player = players[i % players.count]
            i += 1
        }
    }
    
    func assignDraggablesAndRotations() {
        let ma = max(draggables.count, rotations.count)
        let mi = min(draggables.count, rotations.count)
        for i in 0..<ma {
            draggables[i % mi].player = players[i % players.count]
            rotations[i % mi].player = players[i % players.count]
        }
    }
    
}

