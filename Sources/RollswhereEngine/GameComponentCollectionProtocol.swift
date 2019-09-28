protocol GameComponentCollectionProtocol {
    
    var shootables: [Shootable] {
        get
    }
    
    var draggables: [DragComponent] {
        get
    }
    
    var rotations: [RotateComponent] {
        get
    }
    
    var starts: [StartComponent] {
        get
    }
    
    var finishes: [FinishComponent] {
        get
    }
        
}
