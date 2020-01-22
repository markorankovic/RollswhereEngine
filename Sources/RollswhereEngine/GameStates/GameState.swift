import GameplayKit

class GameState: GKState {
    var game: Game? { return (stateMachine as? GameStateMachine)?.game }
    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) { }
    func keyDown(event: NSEvent) { }
    func keyUp(event: NSEvent) { }
    func mouseMoved(event: NSEvent) { }
}
