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
        guard let hookComponents = game?.each(GrapplingHookComponent.self) else {
            return
        }
        guard let activatorComponents = game?.each(ActivatorComponent.self) else {
            return
        }
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
        guard let scene = (game?.currentLevel?.gamescene.rootNode as? GameScene) else {
            return
        }
        
        scene.followShootable(shootable: shootableComponent)

        for hookComponent in hookComponents {
            if hookComponent.contactsShootable(shootable: shootableComponent) {
                hookComponent.attachTo(shootableComponent)
            }
            hookComponent.update(deltaTime: seconds)
        }
        for activatorComponent in activatorComponents {
            activatorComponent.evaluate()
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
        shootableComponent.update(deltaTime: seconds)
        (self.stateMachine as? GameStateMachine)?.shootable?.enterReadyIfRested()
    }
    override func mouseMoved(event: NSEvent) {
        guard let hookComponents = game?.each(GrapplingHookComponent.self) else {
            return
        }
        for hookComponent in hookComponents {
            hookComponent.mouseMoved(with: event)
        }
    }
}

