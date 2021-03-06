import SpriteKit
import GameplayKit

public protocol Presenter: AnyObject {
    var scene: SKScene? { get }
        
    func presentScene(_ scene: SKScene?)
}

extension SKView: Presenter { }

public class GameView: SKView {
    
    public var game: Game?
            
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidMoveToWindow() {
        let pan = NSPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        addGestureRecognizer(pan)
    }
    
    @IBAction func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        self.game?.currentGameScene?.panGestureHandler(gestureRecognizer)
    }
    
    public func connectToGame(_ game: Game) {
        self.game = game
        self.game?.view = self
    }
    
}

