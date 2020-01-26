import SpriteKit
import GameplayKit

public protocol Presenter: AnyObject {
    var scene: SKScene? { get }
        
    func presentScene(_ scene: SKScene?)
}

extension SKView: Presenter { }

public class GameView: SKView {
    
    var game: VisualGame?
            
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidMoveToWindow() {
        let pan = NSPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        addGestureRecognizer(pan)
        window?.acceptsMouseMovedEvents = true
        showsPhysics = true
    }
    
    @IBAction func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        self.game?.currentGameScene?.panGestureHandler(gestureRecognizer)
    }
    
    func connectToGame(_ game: VisualGame) {
        self.game = game
        self.game?.view = self
    }
    
}

