//
//  TapNode.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 08.03.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation
import GameplayKit

class TapNode : GKEntity {
    init(node: SKNode, levelNode: Node, speed: Double, increaceScore: @escaping (Double)->Void){
        
        super.init()
        
        let nodeComponent = NodeComponent(with: node)
        addComponent(nodeComponent)
        
        let vc = VerticalNodePositionComponent(timeable: levelNode, speed: speed, shouldSlowDownAroundZero: true)
        addComponent(vc)
        
        let tapComponent = TapComponent(increaceScore: increaceScore)
        addComponent(tapComponent)
        
        let presenceComponent = PresenceComponent()
        addComponent(presenceComponent)
        
        node.userData = ["entity":self] as NSMutableDictionary
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
