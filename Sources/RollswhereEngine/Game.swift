//import Smorgasbord
import GameplayKit

public protocol Game {
    
    var stateMachine: GameStateMachine? { get set }
    
    var players: [Player] { get }
    
    func runLevel(_ level: Level)
    
    func enterNextLevel()
    
    func each<Component: GKComponent>(_: Component.Type) -> [Component]
    
    func returnToStart(shootable: ShootableComponent)
    
    func start()
    
    var currentLevel: Level? { get set }
    
    var gameRule: GameRule { get set }
    
}
