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
    init(node: SKNode, speed: Double, removeFromScene: @escaping (GKEntity)->Void, increaceScore: @escaping (Double)->Void){
        self.removeFromScene = removeFromScene
        
        super.init()
        
        let nodeComponent = NodeComponent(with: node)
        addComponent(nodeComponent)
        
        let mdComponent = MoveDownComponent(speed: speed)
        addComponent(mdComponent)
        
        let tapComponent = TapComponent(increaceScore: increaceScore)
        addComponent(tapComponent)
        
        let presenceComponent = PresenceComponent()
        addComponent(presenceComponent)
        
        node.userData = ["entity":self] as NSMutableDictionary
    }
    
    private var removeFromScene: (GKEntity)->Void
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func annihilateSelf(){
        if let node = component(ofType: NodeComponent.self)?.node{
            node.removeFromParent()
        }
        removeFromScene(self)
    }
}
