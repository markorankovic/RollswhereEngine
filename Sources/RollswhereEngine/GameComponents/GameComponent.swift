import SpriteKit
import GameplayKit

open class GameComponent: GKComponent {
    var player: Player?
    var nodeComponent: GKSKNodeComponent? {
        entity?.component(ofType: GKSKNodeComponent.self)
    }
}
