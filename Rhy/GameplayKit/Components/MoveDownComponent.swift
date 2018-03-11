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
    
    /// Returns an object initialized with given speed.
    ///
    /// - Parameter speed: Speed of node in pixels per second.
    init(speed: Double){
        self.speed = speed
        super.init()
    }
    
    /// Speed of node movement in pixels per second.
    var speed: Double
    
    
    /// Speed multiplyer.
    var scale: Double = 1
    
    var nodeComponent : NodeComponent?{
        get{
            return entity?.component(ofType: NodeComponent.self)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        nodeComponent?.node.position.y -= CGFloat(seconds*speed*scale)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
