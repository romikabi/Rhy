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
    var viewController: UIViewController?
    
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
    private var songStatus: SKSpriteNode?
    
    private var endScreen: SKSpriteNode?
    private var ratingEndLabel: SKLabelNode?
    private var scoreEndLabel: SKLabelNode?
    private var streakEndLabel: SKLabelNode?
    private var retry: SKLabelNode?
    private var menu: SKLabelNode?
    private var blur: SKSpriteNode?
    
    
    // Other
    var songId : String?
    private var features: LevelFeatures = LevelFeatures()
    private let yStart = 10000 //large enough to be out of the screen
    private var globalSpeed : Double = 500
    private var score: Double = 0{
        didSet{
            scoreLabel?.text = "\(Int(score))"
        }
    }
    private var streak: Int = 0{
        didSet{
            if streak > maxStreak{
                maxStreak = streak
            }
            streakLabel?.text = "\(streak)"
        }
    }
    private var maxStreak = 0
    private var level: Level?{
        didSet{
            guard let level = level else { return }
            
            for node in level.nodes{
                let en = TapNode(node: createNode(on: node.line), levelNode: node, speed: globalSpeed, increaceScore: increaceScore(score:))
                self.entities.append(en)
            }
            
            startTime = CACurrentMediaTime()
            self.musicPlayerManager.beginPlayback(itemID: self.songId!)
        }
    }
    
    var musicPlayerManager = MusicPlayerManager()
    
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
        
        songId = id
        self.level = level
        
    }
    
    override func didMove(to view: SKView) {
        view.isMultipleTouchEnabled = true
    }
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        
        self.timeLabel = self.childNode(withName: "//timeLabel") as? SKLabelNode
        self.scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        self.streakLabel = self.childNode(withName: "//streakLabel") as? SKLabelNode
        self.songStatus = self.childNode(withName: "//songStatus") as? SKSpriteNode
        
        self.endScreen = self.childNode(withName: "//endScreen") as? SKSpriteNode
        self.ratingEndLabel = self.childNode(withName: "//rating") as? SKLabelNode
        self.scoreEndLabel = self.childNode(withName: "//score") as? SKLabelNode
        self.streakEndLabel = self.childNode(withName: "//streak") as? SKLabelNode
        self.retry = self.childNode(withName: "//retry") as? SKLabelNode
        self.menu = self.childNode(withName: "//menu") as? SKLabelNode
        self.blur = self.childNode(withName: "//blur") as? SKSpriteNode
        
        self.endScreen?.alpha = 0
        self.blur?.alpha = 0
        
        let w = self.size.width
        self.genericNode = SKShapeNode.init(circleOfRadius: w/11)
        if let spinnyNode = self.genericNode {
            spinnyNode.lineWidth = 2
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if musicPlayerManager.musicPlayerController.playbackState == .paused{
            return
        }
        for touch in touches{
            for node in self.nodes(at: touch.location(in: self)){
                if let entity = node.userData?["entity"] as? GKEntity, let tapComp = entity.component(ofType: TapComponent.self){
                    tapComp.tap()                    
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if musicPlayerManager.musicPlayerController.playbackState == .paused{
            self.musicPlayerManager.togglePlayPause()
            
            blur?.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
        }
        for touch in touches{
            for node in self.nodes(at: touch.location(in: self)){
                if node.name == "pause"{
                    musicPlayerManager.togglePlayPause()
                    blur?.run(SKAction.fadeAlpha(to: 0.5, duration: 0.2))
                }
                if node.name == "menu"{
                    viewController?.performSegue(withIdentifier: "goToInitial", sender: viewController)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let currentTime = musicPlayerManager.musicPlayerController.currentPlaybackTime
        if musicPlayerManager.musicPlayerController.playbackState != .playing{
            return
        }
        
        // Called before each frame is rendered
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        if currentTime > Double(level?.length ?? 0) / 1000{
            gameEnded = true
            endGame()
        }
        
        if gameEnded{
            return
        }
        
        // Calculate time since last update
        //let dt = currentTime - self.lastUpdateTime
        
        let time = currentTime
        //        let m = Int(time / 60)
        //        let s = Int(time - Double(m*60))
        //        let ms = Int(time.truncatingRemainder(dividingBy: 1) * 1000)
        //        timeLabel?.text = "\((currentTime < startTime ? "-" : ""))\(m):\(s):\(ms)"
        
        if let level = level{
            let progress = time / (Double(level.length)/1000)
            self.songStatus?.xScale = CGFloat(progress)
        }
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: currentTime)
            
            if let node = entity.component(ofType: NodeComponent.self)?.node, let tapped = entity.component(ofType: TapComponent.self)?.tapped {
                if node.position.y < -300, tapped == false {
                    streak = 0
                    entity.component(ofType: TapComponent.self)?.tapped = true
                }
            }
        }
        
        self.lastUpdateTime = currentTime
    }
    
    private var gameEnded = false
    
    func endGame(){
        musicPlayerManager.musicPlayerController.pause()
        guard let level = level else {return}
        let ratingPerc = score / Double(level.nodes.count*100)
        var mark : String
        switch ratingPerc {
        case let x where x.isEqual(to: 1):
            mark = "S"
        case let x where x >= 0.8:
            mark = "A"
        case let x where x >= 0.6:
            mark = "B"
        case let x where x >= 0.4:
            mark = "C"
        case let x where x >= 0.2:
            mark = "D"
        default:
            mark = "E"
        }
        
        ratingEndLabel?.text = mark
        
        scoreEndLabel?.text = "\(Int(score))"
        
        streakEndLabel?.text = "\(maxStreak)"
        
        blur?.run(SKAction.fadeAlpha(to: 0.5, duration: 1))
        endScreen?.run(SKAction.fadeAlpha(to: 1, duration: 1))
        
        
    }
}

extension GameScene {
    func increaceScore(score: Double) {
        self.score += score
        streak+=1
    }
    
    func createNode(on line: Int) -> SKNode {
        if let n = genericNode?.copy() as? SKShapeNode{
            let lineNode = lines[line]
            n.position = CGPoint(x: 0, y: yStart)
            
            n.setColor(line: line)
            
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
