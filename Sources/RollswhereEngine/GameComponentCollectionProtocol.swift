import SpriteKit
import GameplayKit

protocol GameComponentCollectionProtocol {
    
    var shootables: [Shootable] {
        get
    }
    
    var draggables: [Draggable] {
        get
    }
    
    var starts: [StartComponent] {
        get
    }
    
    var finishes: [FinishComponent] {
        get
    }
    
}
