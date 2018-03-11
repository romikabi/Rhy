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
    var colorScheme: [UIColor] = [
        UIColor(hex: "#5bc3eb"),
        UIColor(hex: "#3bb273"),
        UIColor(hex: "#f06449"),
        UIColor(hex: "#787980"),
        UIColor(hex: "#fffb96")
    ]
}

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    // Time variables
    private var lastUpdateTime : TimeInterval = 0
    private var startTime: TimeInterval = 0
    
    // Copiable samples
    private var genericNode : SKShapeNode?
    
    // References to important nodes
    private var lines: [SKNode] = []
    private var horizontal: SKShapeNode?
    private var timeLabel: SKLabelNode?
    private var scoreLabel: SKLabelNode?
    private var streakLabel: SKLabelNode?
    
    // Other
    private var features: LevelFeatures = LevelFeatures()
    private let yStart = 1000
    private var score: Double = 0{
        didSet{
            scoreLabel?.text = "\(Int(score))"
        }
    }
    private var streak: Int = 0{
        didSet{
            streakLabel?.text = "\(streak)"
        }
    }
    private var level: Level?{
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
            
            let nodespawner = NodeSpawner(level: level!, target: self, startTime: -3)
            self.entities.append(nodespawner)
            startTime = CACurrentMediaTime() + 3
        }
    }
    
    func initiate(with level: Level, song id: String){
        for line in lines{
            line.removeFromParent()
        }
        lines.removeAll()
        
        let y = -self.size.height / 2 + 150
        let lineShift = CGFloat(level.lines - 1) / 2
        
        for line in 0...level.lines{
            let shiftedLine = CGFloat(line) - lineShift
            let x = self.size.width / CGFloat(level.lines + 1) * shiftedLine
            
            let lineNode = SKNode()
            lineNode.position = CGPoint(x: x, y: y)
            
            lines.append(lineNode)
            addChild(lineNode)
        }
        
        let horizontal = SKShapeNode(rectOf: CGSize(width: self.size.width, height: 3))
        horizontal.position = CGPoint(x: 0, y: y)
        horizontal.zPosition = -1
        horizontal.fillColor = features.colorScheme[3]
        horizontal.strokeColor = features.colorScheme[3]
        self.horizontal = horizontal
        addChild(horizontal)
        
        self.level = level
    }
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        
        self.timeLabel = self.childNode(withName: "//timeLabel") as? SKLabelNode
        self.scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        self.streakLabel = self.childNode(withName: "//streakLabel") as? SKLabelNode
        
        let w = self.size.width
        self.genericNode = SKShapeNode.init(circleOfRadius: w/12)
        if let spinnyNode = self.genericNode {
            spinnyNode.lineWidth = 2
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // relocate to component
        for touch in touches{
            for node in self.nodes(at: touch.location(in: self)){
                if let entity = node.userData?["entity"] as? GKEntity{
                    if let tapComp = entity.component(ofType: TapComponent.self){
                        tapComp.tap()
                    }
                }
                
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        let time = abs(currentTime - startTime)
        let m = Int(time / 60)
        let s = Int(time - Double(m*60))
        let ms = Int(time.truncatingRemainder(dividingBy: 1) * 1000)
        timeLabel?.text = "\((currentTime < startTime ? "-" : ""))\(m):\(s):\(ms)"
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}

extension GameScene : NodeSpawnTarget{
    func increaceScore(score: Double) {
        self.score += score
        streak+=1
    }
    
    func createNode(on line: Int) -> SKNode {
        if let n = genericNode?.copy() as? SKShapeNode{
            let lineNode = lines[line]
            n.position = CGPoint(x: 0, y: yStart)
            
            switch line{
            case 0:
                n.fillColor = features.colorScheme[0]
                n.strokeColor = features.colorScheme[0]
            case 1:
                n.fillColor = features.colorScheme[1]
                n.strokeColor = features.colorScheme[1]
            case 2:
                n.fillColor = features.colorScheme[2]
                n.strokeColor = features.colorScheme[2]
            default:
                ()
            }
            n.alpha = 0
            lineNode.addChild(n)
            return n
        }
        return SKNode()
    }
    
    func addEntity(entity: GKEntity) {
        entities.append(entity)
    }
    
    func removeEntity(entity: GKEntity) {
        if let index = entities.index(of: entity){
            entities.remove(at: index)
        }
    }
}
