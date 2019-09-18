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
        showsPhysics = true
    }
    
    @IBAction func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        //DispatchQueue.main.async {
            self.game?.currentGameScene?.panGestureHandler(gestureRecognizer)
        //}
    }
    
    public func connectToGame(_ game: Game) {
        self.game = game
        self.game?.view = self
    }
    
}

