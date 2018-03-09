//
//  GameScene.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 22.02.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import SpriteKit
import GameplayKit

class LevelFeatures{
    var timeToPassScreen: Int = 2000
    var colorScheme: [UIColor] = [
        UIColor(hex: "#ff71ce"),
        UIColor(hex: "#01cdfe"),
        UIColor(hex: "#05ffa1"),
        UIColor(hex: "#b967ff"),
        UIColor(hex: "#fffb96")
    ]
}

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var genericNode : SKShapeNode?
    private var startTime: TimeInterval = 0
    var level: Level?{
        didSet{
            if level == nil{
                return
            }
            
            for e in entities{
                if let _ = e.component(ofType: NodeSpawnComponent.self){
                    entities.remove(at: entities.index(of: e)!)
                    break
                }
            }
            
            let nodespawner = NodeSpawner(level: level!, target: self)
            self.entities.append(nodespawner)
        }
    }
    
    private var features: LevelFeatures = LevelFeatures()
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        
        let w = self.size.width
        self.genericNode = SKShapeNode.init(circleOfRadius: w/12)
        if let spinnyNode = self.genericNode {
            spinnyNode.lineWidth = 2
        }
    
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        if self.startTime == 0{
            self.startTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}

extension GameScene : NodeSpawnTarget{
    
    func createNode(on line: Int) -> SKNode {
        if let n = genericNode?.copy() as? SKShapeNode{
            let width = self.size.width
            let x = (width/4)*CGFloat(line+1)-width/2
            let y = self.size.height/2
            n.position = CGPoint(x: x, y: y)
            switch line{
            case 0:
                n.fillColor = features.colorScheme[0]
                n.strokeColor = features.colorScheme[1]
            case 1:
                n.fillColor = features.colorScheme[1]
                n.strokeColor = features.colorScheme[2]
            case 2:
                n.fillColor = features.colorScheme[2]
                n.strokeColor = features.colorScheme[0]
            default:
                ()
            }
            self.addChild(n)
            return n
        }
        return SKNode()
    }
    
    func addEntity(entity: GKEntity) {
        entities.append(entity)
    }
    
    func getSize() -> CGSize{
        return self.size
    }
}
