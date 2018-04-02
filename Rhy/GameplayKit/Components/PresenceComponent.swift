//
//  PresenceComponent.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 11.03.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation
import GameplayKit

class PresenceComponent : GKComponent {
    override init(){
        super.init()
        self.fadeOut(withDuration: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var node: SKNode?{
        get{
            return self.entity?.component(ofType: NodeComponent.self)?.node
        }
    }
    
    func fadeIn(withDuration sec: TimeInterval){
        node?.run(SKAction.fadeIn(withDuration: sec))
    }
    func fadeOut(withDuration sec: TimeInterval){
        node?.run(SKAction.fadeOut(withDuration: sec))
    }
    
    func popOut(expTime: TimeInterval, inTime: TimeInterval){
        node?.run(SKAction.sequence([
            SKAction.scale(to: 1.2, duration: expTime),
            SKAction.scale(to: 0, duration: inTime),
            SKAction.fadeAlpha(to: 0, duration: 0),
            SKAction.scale(to: 1, duration: 0)
            ]))
    }
}
