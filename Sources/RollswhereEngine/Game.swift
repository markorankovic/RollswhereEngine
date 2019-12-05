import SpriteKit
import GameplayKit
//import Smorgasbord

open class Game {
    
    public var stateMachine: GameStateMachine?
    public weak var view: Presenter?
    public var currentScene: GKScene?
    public var currentGameScene: GameScene? { currentScene?.rootNode as? GameScene }

    public init() {
        stateMachine = GameStateMachine(states: [
            EnterLevelState(),
            PlayingState(),
            MainMenuState(),
            TransitionState()
        ])
        stateMachine?.game = self
    }
        
    public func each<Component: GKComponent>(_: Component.Type) -> [Component] {
        return currentScene?.each(Component.self) ?? []
    }
    
    var players: [Player] {
        guard let level = currentScene else { return [] }
        return level.entities.compactMap{ $0 as? Player }
    }

    func getEntities(nodes: [SKNode]) -> [GKEntity] {return nodes.compactMap{ $0.entity }}
    
    func addPlayers(to level: GKScene, players: [Player]) { for player in players { level.addEntity(player) } }
    
    func getPlayersFromShootables() -> [Player] {
        let shootableNodes = each(ShootableComponent.self).compactMap{ $0.nodeComponent?.node }
        var players: [Player] = []
        let arr = (shootableNodes.compactMap{ $0.userData?["shootablecomponent"] as? Int })
        let set = Set(arr)
        for _ in set {
            players.append(Player(game: self))
        }
        return players
    }
    
    func addAndlinkNodesAndEntities() {
        guard let children = currentGameScene?.children else {
            return
        }
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
                case "rotateable": components.append(RotateableComponent())
                case "start": components.append(StartComponent())
                case "finish": components.append(FinishComponent())
                default: break
                }
            }
            if !components.isEmpty {
                let entity = GKEntity()
                for component in components {
                    entity.addComponent(component)
                }
                entity.addComponent(GKSKNodeComponent(node: node))
                currentScene?.addEntity(entity)
            }
        }
    }
    
    open func runLevel(_ level: GKScene) {
        currentScene = level
        guard let scene = level.rootNode as? GameScene else { return }
        if scene.name == "gksceneinitoutoforder" {
            print("GKScene initializer is out of order")
            addAndlinkNodesAndEntities()
        }
        view?.presentScene(scene)
        addPlayers(to: level, players: getPlayersFromShootables())
        assignStarts()
        assignDraggables()
        assignRotations()
        assignShootables()
        for shootable in each(ShootableComponent.self) {
            shootable.stateMachine?.game = self
        }
        stateMachine?.enter(EnterLevelState.self)
    }
    
    var currentLevelIndex = 1
    
    let levels = 2
    
    func enterNextLevel() {
        currentLevelIndex = (currentLevelIndex % levels) + 1
        let level = GKScene()
        let scene = GameScene(fileNamed: "Level\(currentLevelIndex)")!
        level.rootNode = scene
        runLevel(level)
    }
    
    func assignStarts() { // Only works if start nodes are sorted left-right min-max
        let startComponents = each(StartComponent.self)
        for shootable in each(ShootableComponent.self) {
            guard let shootableNodeData = shootable.nodeComponent?.node.userData else { continue }
            guard let index = shootableNodeData["startcomponent"] as? Int else { continue }
            startComponents[index].shootable = shootable
        }
    }
        
    func assignDraggables() { associateComponentsWithPlayer(each(DraggableComponent.self)) }
    func assignRotations() { associateComponentsWithPlayer(each(RotateableComponent.self)) }
    func assignShootables() { associateComponentsWithPlayer(each(ShootableComponent.self)) }
    
    func getPlayerFromComponentSKNodeData(_ component: GameComponent) -> Player? {
        guard let nodeData = component.nodeComponent?.node.userData else { return nil }
        print("\(component.className.lowercased().split(separator: ".")[1])")
        guard let i = nodeData["\(component.className.lowercased().split(separator: ".")[1])"] as? Int else {
            return nil
        }
        guard i < players.count && i >= 0 else { return nil }
        print(i)
        return players[i]
    }
    
    func associateComponentsWithPlayer(_ components: [GameComponent]) {
        for component in components {
            component.player = getPlayerFromComponentSKNodeData(component)
        }
    }
    
}
