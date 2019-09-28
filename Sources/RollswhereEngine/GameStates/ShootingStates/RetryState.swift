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
    }
        
    override func update(deltaTime seconds: TimeInterval) {
        (self.stateMachine as? GameStateMachine)?.shootable?.enterReadyIfRested()
    }

}
