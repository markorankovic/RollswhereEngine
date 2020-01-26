import GameplayKit
import SpriteKit

public class VisualGame: Game {
    
    public func enterNextLevel() {
        currentLevelIndex += 1
        currentLevelIndex = 5
        let nextLevel = SKSToVisualLevelConverter.sksToVisualLevel(filenamed: "Level\(currentLevelIndex)", game: self)
        runLevel(nextLevel)
    }
    
    public var stateMachine: GameStateMachine?
    public weak var view: Presenter?
    public var currentLevel: Level?
    public var currentScene: GKScene? { (currentLevel as? VisualLevel)?.gamescene }
    public var currentGameScene: GameScene? { currentScene?.rootNode as? GameScene }
    public var gameRule: GameRule = .Campaign
    
    public var players: [Player] {
        guard let currentScene = currentScene else {
            return []
        }
        return currentScene.entities.compactMap{ $0 as? Player }
    }

    public init() {
        stateMachine = GameStateMachine(states: [
            EnterLevelState(),
            PlayingState(),
            MainMenuState(),
            TransitionState()
        ])
        stateMachine?.game = self
    }
    
    public func start() {
        currentLevelIndex = 0
        enterNextLevel()
    }
        
    public func returnToStart(shootable: ShootableComponent) {
        guard let scene = currentGameScene else { return }
        guard let startComponent = (each(StartComponent.self).filter{ $0.shootable == shootable }.first) else {
            return
        }
        guard let startNode = startComponent.nodeComponent?.node.childNode(withName: "tex") else {
            return
        }
        let returnPos = scene.convert(.init(), from: startNode)
        shootable.nodeComponent?.node.position = returnPos
    }
    
    public func each<Component: GKComponent>(_: Component.Type, _ level: GKScene) -> [Component] {
        return level.each(Component.self)
    }
    
    public func each<Component: GKComponent>(_: Component.Type) -> [Component] {
        return currentScene?.each(Component.self) ?? []
    }
        
    public func runLevel(_ level: Level) {
        self.currentLevel = level
        guard let scene = self.currentGameScene else { return }
        self.view?.presentScene(scene)
        print(currentGameScene!.view!.frame.size)
        self.stateMachine?.enter(EnterLevelState.self)
    }
    
    var currentLevelIndex = 2
    let levels = 1
        
}

