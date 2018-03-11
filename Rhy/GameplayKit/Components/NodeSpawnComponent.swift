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
    func removeEntity(entity: GKEntity)
    func increaceScore(score: Double)
}

class NodeSpawnComponent : GKComponent {
    var level: Level
    var target: NodeSpawnTarget
    private var timePassed: TimeInterval = 0
    
    init(level: Level, target: NodeSpawnTarget, startTime: TimeInterval){
        self.level = level
        self.target = target
        self.timePassed = startTime
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let currentTime = timePassed + seconds
        
        for n in level.nodes{
            let time = Double(n.time)/1000 - 2 //todo decompose magic numbers
            
            if time < timePassed{
                continue
            }
            if time > currentTime{
                break
            }
            
            let sknode = target.createNode(on: n.line)
            let tapnode = TapNode(node: sknode, speed: 500, removeFromScene: target.removeEntity(entity:), increaceScore: target.increaceScore(score:))
            target.addEntity(entity: tapnode)
            if let presence = tapnode.component(ofType: PresenceComponent.self){
                presence.fadeIn(withDuration: 0.2)
            }
        }
        
        timePassed = currentTime
    }
}
