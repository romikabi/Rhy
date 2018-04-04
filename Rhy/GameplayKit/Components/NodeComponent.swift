//
//  NodeComponent.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 08.03.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation
import GameplayKit

class NodeComponent : GKComponent {
    var node : SKNode
    var parent: SKNode
    var inParent: Bool
    
    init(with node: SKNode, in parent: SKNode){
        self.node = node
        self.parent = parent
        node.removeFromParent()
        inParent = false
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
