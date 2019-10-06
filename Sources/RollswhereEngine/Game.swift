import SpriteKit
import GameplayKit
import Smorgasbord

open class Game {
        
    public init() {
        stateMachine = GameStateMachine(states: [
            EnterLevelState(),
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
    public var currentGameScene: GameScene? { currentScene?.rootNode as? GameScene }
                
    var players: [Player] {
        guard let level = currentScene else { return [] }
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
    
    func getPlayersFromShootables() -> [Player] {
        let shootableNodes = each(Shootable.self).compactMap{ $0.nodeComponent?.node }
        var players: [Player] = []
        let arr = (shootableNodes.compactMap{ $0.userData?["shootable"] as? Int })
        let set = Set(arr)
        for _ in set {
            players.append(Player(game: self))
        }
        return players
    }
    
    open func runLevel(_ level: GKScene) {
        currentScene = level
        guard let scene = level.rootNode as? GameScene else { return }
        
        addPlayers(to: level, players: getPlayersFromShootables())
        
        assignStarts()
        assignDraggables()
        assignRotations()
        assignShootables()
                        
        stateMachine?.enter(EnterLevelState.self)
        view?.presentScene(scene)
    }
    
    func assignStarts() { // Only works if start nodes are sorted left-right min-max
        let startComponents = each(StartComponent.self)
        for shootable in each(Shootable.self) {
            guard let shootableNodeData = shootable.nodeComponent?.node.userData else { continue }
            guard let index = shootableNodeData["start"] as? Int else { continue }
            startComponents[index].shootable = shootable
        }
    }
        
    func assignDraggables() {
        associateComponentsWithPlayer(each(DragComponent.self))
    }
    
    func assignRotations() {
        associateComponentsWithPlayer(each(RotateComponent.self))
    }
    
    func assignShootables() {
        associateComponentsWithPlayer(each(Shootable.self))
    }
        
    func getPlayerFromComponentSKNodeData(_ component: GameComponent) -> Player? {
        guard let nodeData = component.nodeComponent?.node.userData else {
            return nil
        }
        guard let i = nodeData["\(component.className.lowercased().split(separator: ".")[1])"] as? Int else {
            return nil
        }
        guard i < players.count && i >= 0 else {
            return nil
        }
        return players[i]
    }
    
    func associateComponentsWithPlayer(_ components: [GameComponent]) {
        for component in components {
            component.player = getPlayerFromComponentSKNodeData(component)
        }
    }
    
}
