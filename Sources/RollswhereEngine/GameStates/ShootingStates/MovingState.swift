//import Smorgasbord
import GameplayKit

class MovingState: GameState {
    override func didEnter(from previousState: GKState?) {
        print("moving")
    }
    override func keyDown(event: NSEvent) {
        (self.stateMachine as? GameStateMachine)?.shootable?.keyDown(event)
    }
    override func update(deltaTime seconds: TimeInterval) {
        guard let finishComponents = game?.each(FinishComponent.self) else {
            return
        }
        guard let shootableComponent = (stateMachine as? GameStateMachine)?.shootable else {
            return
        }
        for finishComponent in finishComponents {
            if finishComponent.inContactWithTrigger(shootable: shootableComponent) {
                game?.stateMachine?.enter(TransitionState.self)
                return
            }
        }
        DispatchQueue.main.async {
            (self.stateMachine as? GameStateMachine)?.shootable?.enterReadyIfRested()
        }
    }
}
