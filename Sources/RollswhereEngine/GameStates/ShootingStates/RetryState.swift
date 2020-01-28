import GameplayKit

class RetryState: GameState {
        
    override func didEnter(from previousState: GKState?) {
        guard let shootable = (stateMachine as? GameStateMachine)?.shootable else {
            return
        }
        if let previousState = previousState {
            if previousState is EnterLevelState {
                print("Getting ready to shoot")
            } else {
                print("Retrying attempt")
            }
            shootable.removeGrapplingHook()
        }
        game?.returnToStart(shootable: shootable)
        shootable.deactivatePhysics()
        shootable.resetRotation()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        DispatchQueue.main.async {
            (self.stateMachine as? GameStateMachine)?.shootable?.enterReadyIfRested()
        }
    }

}
