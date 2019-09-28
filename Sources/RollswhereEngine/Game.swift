import SpriteKit
import GameplayKit

extension Sequence {
    func first<T>(_: T.Type) -> T? {
        return first{ $0 is T } as? T
    }
}

extension GKScene {
    func each<T: GKComponent>(_: T.Type) -> [T] {
        return entities.compactMap{ $0.components.first(T.self) }
    }
}

open class Game {
        
    public init() {
        stateMachine = GKStateMachine(states: [
            MainMenuState(),
            PlayingState()
        ])
    }
    
    public func each<Component: GKComponent>(_: Component.Type) -> [Component] {
        return currentScene?.each(Component.self) ?? []
    }
        
    public var stateMachine: GKStateMachine?
         
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
                let player = Player()
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
        print(level.entities)
        stateMachine?.enter(PlayingState.self)
        view?.presentScene(scene)
    }
    
    func assignStarts() {
        var i = 0
        for start in each(StartComponent.self) {
            start.player = players[i % players.count]
            i += 1
        }
    }
        
    func assignDraggablesAndRotations() {
        
        guard players.count > 0 else {
            return
        }
        
        let draggables = each(DragComponent.self)
        let rotations = each(RotateComponent.self)
        
        let ma = max(draggables.count, rotations.count)
        let mi = min(draggables.count, rotations.count)
        for i in 0..<ma {
            draggables[i % (ma == draggables.count ? ma : mi)].player = players[i % players.count]
            rotations[i % (ma == rotations.count ? ma : mi)].player = players[i % players.count]
        }
        
    }
    
}

         
