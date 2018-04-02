//
//  VerticalNodePositionComponent.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 01.04.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import UIKit
import GameplayKit

class VerticalNodePositionComponent: GKComponent {
    init(timeable: Timeable, speed: Double, shouldSlowDownAroundZero: Bool = false){
        self.timeable = timeable
        self.speed = speed
        self.slowAroundZero = shouldSlowDownAroundZero
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var slowAroundZero = false
    var timeable : Timeable
    var speed : Double
    var scale : Double = 1
    private var skNode : SKNode? {
        get{
            return self.entity?.component(ofType: NodeComponent.self)?.node
        }
    }
    private var presenceComponent : PresenceComponent?{
        get{
            return self.entity?.component(ofType: PresenceComponent.self)
        }
    }
    private let zeroScale = 0.3
    private let zeroTimeBound = 0.2
    /// deltaTime is used as total time from the start of the song.
    override func update(deltaTime seconds: TimeInterval) {
        let time = timeable.timeInterval
        var scaleAroundZero = 1.0
        if slowAroundZero && abs(seconds-time) < zeroTimeBound{
            let dist = abs(seconds-time) * ((1-zeroScale)/zeroTimeBound) + zeroScale
            scaleAroundZero *= dist
        }
        let y = CGFloat((time - seconds) * speed * scale * scaleAroundZero)
        if y.abs < 2000 || skNode?.position.y.abs ?? 0 < 2000{
            skNode?.position.y = y
        }
        
        guard let node = skNode else { return }
        
        switch node.position.y{
        case let y where y < -300:
            presenceComponent?.fadeOut(withDuration: 0.1)
            
        case let y where y < 1000 && y > 101:
            presenceComponent?.fadeIn(withDuration: 0.1)
            
        default: ()
        }
    }
}
