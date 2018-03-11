//
//  TapComponent.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 28.02.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation
import GameplayKit

class TapComponent : GKComponent{
    var presenceComponent: PresenceComponent?{
        get{
            return entity?.component(ofType: PresenceComponent.self)
        }
    }
    
    var moveDownComponent: MoveDownComponent?{
        get{
            return entity?.component(ofType: MoveDownComponent.self)
        }
    }
    
    var node: SKNode?{
        get{
            return entity?.component(ofType: NodeComponent.self)?.node
        }
    }
    
    init(increaceScore: @escaping (Double)->Void){
        self.increaceScore = increaceScore
        super.init()
    }
    
    var increaceScore: (Double) -> Void
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tap(){
        if let node = node{
            if abs(node.position.y) > 100{
                return
            }
            
            increaceScore(Double(abs(node.position.y)) < 50 ? 100 : 50)
            
            if let presence = presenceComponent{
                presence.popOut(expTime: 0.05, inTime: 0.1)
            }
            
            if let move = moveDownComponent{
                move.scale = 0
            }
        }
    }
}
