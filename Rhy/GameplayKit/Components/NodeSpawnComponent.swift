//
//  NodeSpawnComponent.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 08.03.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation
import GameplayKit

protocol NodeSpawnTarget{
    func createNode(on line: Int) -> SKNode
    func addEntity(entity: GKEntity)
    func getSize() -> CGSize
}

class NodeSpawnComponent : GKComponent {
    var level: Level
    var target: NodeSpawnTarget
    var timePassed: TimeInterval = 0
    
    init(level: Level, target: NodeSpawnTarget){
        self.level = level
        self.target = target
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let currentTime = timePassed + seconds
        
        for n in level.nodes{
            let time = Double(n.time)/1000
            
            if time < timePassed{
                continue
            }
            if time > currentTime{
                break
            }
            
            let sknode = target.createNode(on: n.line)
            let tapnode = TapNode(node: sknode, timeToPassScreen: 2.0, sceneHeight: target.getSize().height)
            target.addEntity(entity: tapnode)
        }
        
        timePassed = currentTime
    }
}
