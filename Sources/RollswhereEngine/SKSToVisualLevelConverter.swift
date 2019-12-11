import GameplayKit
import SpriteKit
//import Smorgasbord

class SKSToVisualLevelConverter {
    
    static public func sksToVisualLevel(filenamed: String, game: Game) -> VisualLevel {
        let gamescene = GKScene()
        let scene = GameScene(fileNamed: filenamed)!
        gamescene.rootNode = scene
        addAndlinkNodesAndEntities(gamescene) // GKScene init not working, hence user data of SKNodes
        let players = getPlayersFromShootables(gamescene: gamescene, game: game)
        addPlayers(to: gamescene, players: players)
        assignStarts(gamescene)
        assignDraggables(gamescene, players)
        assignRotations(gamescene, players)
        assignShootables(gamescene, players)
        for shootable in gamescene.each(ShootableComponent.self) {
            shootable.stateMachine?.game = game
        }
        let level = VisualLevel(gamescene: gamescene)
        return level
    }
    
    static private func addPlayers(to level: GKScene, players: [Player]) { for player in players { level.addEntity(player) } }
    
    static private func getPlayersFromShootables(gamescene: GKScene, game: Game) -> [Player] { // SKS
        let shootableNodes = gamescene.each(ShootableComponent.self).compactMap{ $0.nodeComponent?.node }
        var players: [Player] = []
        let arr = (shootableNodes.compactMap{ $0.userData?["shootablecomponent"] as? Int })
        let set = Set(arr)
        for _ in set {
            players.append(Player(game: game))
        }
        return players
    }
    
    static private func addAndlinkNodesAndEntities(_ gamescene: GKScene) { // SKS
        guard let children = (gamescene.rootNode as? GameScene)?.children else {
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
                gamescene.addEntity(entity)
            }
        }
    }
    
    static private func assignStarts(_ gamescene: GKScene) { // Only works if start nodes are sorted left-right min-max
        let startComponents = gamescene.each(StartComponent.self)
        for shootable in gamescene.each(ShootableComponent.self) {
            guard let shootableNodeData = shootable.nodeComponent?.node.userData else { continue }
            guard let index = shootableNodeData["startcomponent"] as? Int else { continue }
            startComponents[index].shootable = shootable
        }
    }
    
    static private func assignDraggables(_ gamescene: GKScene, _ players: [Player]) {
        associateComponentsWithPlayer(gamescene.each(DraggableComponent.self), players)
    }
    static private func assignRotations(_ gamescene: GKScene, _ players: [Player]) {
        associateComponentsWithPlayer(gamescene.each(RotateableComponent.self), players)
    }
    static private func assignShootables(_ gamescene: GKScene, _ players: [Player]) {
        associateComponentsWithPlayer(gamescene.each(ShootableComponent.self), players)
    }
    
    static private func getPlayerFromComponentSKNodeData(_ component: GameComponent, _ players: [Player]) -> Player? {
        guard let nodeData = component.nodeComponent?.node.userData else { return nil }
        print("\(component.className.lowercased().split(separator: ".")[1])")
        guard let i = nodeData["\(component.className.lowercased().split(separator: ".")[1])"] as? Int else {
            return nil
        }
        guard i < players.count && i >= 0 else { return nil }
        print(i)
        return players[i]
    }
    
    static private func associateComponentsWithPlayer(_ components: [GameComponent], _ players: [Player]) {
        for component in components {
            component.player = getPlayerFromComponentSKNodeData(component, players)
        }
    }

}
