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
    init(node: SKNode, timeToPassScreen time: TimeInterval, sceneHeight: CGFloat){
        super.init()
        
        let nodeComponent = NodeComponent(with: node)
        addComponent(nodeComponent)
        
        let mdComponent = MoveDownComponent(timeToPassScreen: time, height: sceneHeight)
        addComponent(mdComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
