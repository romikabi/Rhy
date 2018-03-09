//
//  NodeSpawner.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 08.03.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation
import GameplayKit

class NodeSpawner : GKEntity{
    init(level: Level, target: NodeSpawnTarget){
        super.init()
        let nsComponent = NodeSpawnComponent(level: level, target: target)
        addComponent(nsComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
