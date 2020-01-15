import GameplayKit

class RetryState: GameState {
        
    override func didEnter(from previousState: GKState?) {
        if let previousState = previousState {
            if previousState is EnterLevelState {
                print("Getting ready to shoot")
            } else {
                print("Retrying attempt")
            }
        }
        guard let shootable = (stateMachine as? GameStateMachine)?.shootable else {
            return
        }
        game?.returnToStart(shootable: shootable)
        shootable.deactivatePhysics()
        shootable.resetRotation()
        (game?.currentLevel?.gamescene.rootNode as? GameScene)?.returnCam()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        DispatchQueue.main.async {
            (self.stateMachine as? GameStateMachine)?.shootable?.enterReadyIfRested()
        }
    }

}
