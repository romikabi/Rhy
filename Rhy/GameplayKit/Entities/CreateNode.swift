//
//  CreateNode.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 01.04.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import UIKit
import GameplayKit

class CreateNode: GKEntity {
    init(node: SKNode, parent: SKNode, levelNode: Node, speed: Double){
        super.init()
        
        let components : [GKComponent] = [
            NodeComponent(with: node, in: parent),
            //PresenceComponent(),
            VerticalNodePositionComponent(timeable: levelNode, speed: speed)
        ]
        
        for component in components{
            self.addComponent(component)
        }
        
        node.userData = ["entity":self, "levelNode": levelNode] as NSMutableDictionary
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
