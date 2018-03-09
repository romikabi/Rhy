//
//  MoveDownComponent.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 08.03.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation
import GameplayKit

class MoveDownComponent : GKComponent{
    init(timeToPassScreen time:TimeInterval, height: CGFloat){
        timeToPassScreen = time
        self.height = Double(height)
        super.init()
    }
    
    var timeToPassScreen : TimeInterval
    var height: Double
    
    var nodeComponent : NodeComponent?{
        get{
            return entity?.component(ofType: NodeComponent.self)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let delta = (height*seconds)/timeToPassScreen
        nodeComponent?.node.position.y -= CGFloat(delta)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
