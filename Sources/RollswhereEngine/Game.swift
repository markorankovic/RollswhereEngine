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
        stateMachine = GameStateMachine(states: [
            PlayingState(),
            MainMenuState()
        ])
        stateMachine?.game = self
    }
    
    public func each<Component: GKComponent>(_: Component.Type) -> [Component] {
        return currentScene?.each(Component.self) ?? []
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
        return level.entities.compactMap{ $0 as? Player }
    }

    func getEntities(nodes: [SKNode]) -> [GKEntity] {
        return nodes.compactMap{ $0.entity }
    }
                
    func addPlayers(to level: GKScene, players: [Player]) {
        for player in players {
            level.addEntity(player)
        }
    }
    
    func getPlayersFromScene(_ scene: GameScene) -> [Player] {
        return scene.children.filter{ $0.name == "playerbox" }.map{
            let p = Player(game: self)
            p.addComponent(GKSKNodeComponent(node: $0))
            return p
        }
    }
    
    open func runLevel(_ level: GKScene) {
        currentScene = level
        
        guard let scene = level.rootNode as? GameScene else { return }
        
        addPlayers(to: level, players: getPlayersFromScene(scene))
        
        assignStarts()
        assignDraggablesAndRotations()
        assignShootables()
                
        stateMachine?.enter(PlayingState.self)
        view?.presentScene(scene)        
    }
    
    func assignStarts() {
        var i = 0
        let shootables = each(Shootable.self)
        for start in each(StartComponent.self) {
            start.shootable = shootables[i % shootables.count]
            i += 1
        }
    }
        
    func assignDraggablesAndRotations() {
        
        guard players.count > 0 else { return }
        
        let draggables = each(DragComponent.self)
        let rotations = each(RotateComponent.self)
        
        let ma = max(draggables.count, rotations.count)
        let mi = min(draggables.count, rotations.count)
        
        for i in 0..<ma {
            draggables[i % (ma == draggables.count ? ma : mi)].player = players[i % players.count]
            rotations[i % (ma == rotations.count ? ma : mi)].player = players[i % players.count]
        }
        
    }
    
    func assignShootables() {
        for shootable in each(Shootable.self) {
            for player in players {
                guard let shootableNode = shootable.entityNodeComponent?.node else { continue }
                guard let playerNode = player.nodeComponent?.node else { continue }
                if playerNode.frame.intersects(shootableNode.frame) {
                    shootable.player = player
                }
            }
        }
    }
    
}
