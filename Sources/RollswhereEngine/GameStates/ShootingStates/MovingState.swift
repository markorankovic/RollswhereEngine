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
        guard let speedBoostComponents = game?.each(SpeedBoostComponent.self) else {
            return
        }
        guard let portalComponents = game?.each(PortalComponent.self) else {
            return
        }
        guard let finishComponents = game?.each(FinishComponent.self) else {
            return
        }
        guard let shootableComponent = (stateMachine as? GameStateMachine)?.shootable else {
            return
        }
        for speedBoostComponent in speedBoostComponents {
            speedBoostComponent.evaluate()
        }
        for portalComponent in portalComponents {
            portalComponent.evaluate()
        }
        for finishComponent in finishComponents {
            if finishComponent.inContactWithTrigger(shootable: shootableComponent) {
                game?.stateMachine?.enter(TransitionState.self)
                return
            }
        }
        (self.stateMachine as? GameStateMachine)?.shootable?.enterReadyIfRested()
    }
}
