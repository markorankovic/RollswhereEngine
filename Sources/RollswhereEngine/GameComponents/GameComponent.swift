import SpriteKit
import GameplayKit

open class GameComponent: GKComponent {
    
    var player: Player? {
        
        set{}
        
        get{
            return entity as? Player
        }
        
    }
    
}
