import SpriteKit
import GameplayKit
import Smorgasbord

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
        let shootableNodes = each(Shootable.self).compactMap{ $0.entityNodeComponent?.node }
        var players: [Player] = []
        let arr = (shootableNodes.compactMap{ $0.userData?["player"] as? Int })
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
                
        print(players)
        
        stateMachine?.enter(PlayingState.self)
        view?.presentScene(scene)
    }
    
    func assignStarts() { // Only works if start nodes are sorted left-right min-max
        let startComponents = each(StartComponent.self)
        for shootable in each(Shootable.self) {
            guard let shootableNodeData = shootable.entityNodeComponent?.node.userData else { continue }
            print(shootableNodeData)
            guard let index = shootableNodeData["start"] as? Int else { continue }
            startComponents[index].shootable = shootable
        }
    }
        
    func assignDraggables() {
        guard players.count > 0 else { return }
        let draggables = each(DragComponent.self)
        for i in 0..<draggables.count {
            draggables[i % draggables.count].player = players[i % players.count]
        }
    }
    
    func assignRotations() {
        guard players.count > 0 else { return }
        let rotations = each(RotateComponent.self)
        for i in 0..<rotations.count {
            rotations[i % rotations.count].player = players[i % players.count]
        }
    }
    
    func assignShootables() {
        for shootable in each(Shootable.self) {
            guard let shootableNodeData = shootable.entityNodeComponent?.node.userData else { continue }
            guard let playerIndex = shootableNodeData["player"] as? Int else { continue }
            shootable.player = players[playerIndex]
        }
    }
    
}

