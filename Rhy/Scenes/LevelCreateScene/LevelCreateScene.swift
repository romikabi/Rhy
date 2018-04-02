//
//  LevelCreateScene.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 01.04.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class LevelCreateScene: SKScene {
    var viewController: UIViewController?
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lines : [SKNode] = []
    private var horizontal : SKSpriteNode?
    private var genericNode: SKShapeNode?
    private var genericLine: SKSpriteNode?
    
    private var pauseNode: SKSpriteNode?
    private var nodeDensity: SKLabelNode?
    private var nodeAmount: SKLabelNode?
    private var menuScreen: SKSpriteNode?
    private var blur: SKSpriteNode?
    
    private let pauseName = "pause"
    private let forwardName = "forward"
    private let backwardName = "backward"
    private let horizontalName = "horizontal"
    private let densityName = "nodeDensity"
    private let amountName = "nodeAmount"
    private let menuName = "menu"
    private let menuScreenName = "menuScreen"
    private let mainMenuName = "mainMenu"
    private let blurName = "blur"
    private let closeName = "close"
    private let refineName = "refine"
    
    private var songId : String?
    private var musicPlayerManager = MusicPlayerManager()
    private var level: Level?
    private var globalSpeed : Double = 600
    
    private var playing : Bool{
        get{
            return musicPlayerManager.musicPlayerController.playbackState == .playing
        }
    }
    
    override func sceneDidLoad() {
        self.horizontal = self.childNode(withName: "//\(horizontalName)") as? SKSpriteNode
        self.pauseNode = self.childNode(withName: "//\(pauseName)") as? SKSpriteNode
        self.genericLine = self.childNode(withName: "//genericLine") as? SKSpriteNode
        
        self.nodeDensity = self.childNode(withName: "//\(densityName)") as? SKLabelNode
        self.nodeAmount = self.childNode(withName: "//\(amountName)") as? SKLabelNode
        self.menuScreen = self.childNode(withName: "//\(menuScreenName)") as? SKSpriteNode
        self.blur = self.childNode(withName: "//\(blurName)") as? SKSpriteNode
        
        menuScreen?.alpha = 0
        blur?.alpha = 0
        
        let w = self.size.width
        self.genericNode = SKShapeNode.init(circleOfRadius: w/11)
        if let spinnyNode = self.genericNode {
            spinnyNode.lineWidth = 2
            spinnyNode.name = "node"
        }
    }
    
    func initiate(song id: String, lineAmount: Int = 3){
        songId = id
        
        createLines(lineAmount: lineAmount)
        self.level = initiateLevel(title: "title", lines: lineAmount, songId: id)
        
        musicPlayerManager.beginPlayback(itemID: id)    
    }
    
    func createHorizontals(duration: TimeInterval){
        var lineTime : TimeInterval = 0
        while lineTime <= duration{
            let entity = GKEntity()
            let timeable = LineNode()
            timeable.timeInterval = lineTime
            entity.addComponent(VerticalNodePositionComponent(timeable: timeable, speed: globalSpeed))
            if let node = genericLine?.copy() as? SKSpriteNode{
                node.alpha = 0.5
                horizontal?.addChild(node)
                entity.addComponent(NodeComponent(with: node))
                entities.append(entity)
                lineTime+=1
            }
        }
    }
    
    func initiateLevel(title: String, lines: Int, songId: String, author: String? = nil)->Level{
        let level = Level(title: title, lines: lines, songId: songId)
        level.author = author
        return level
    }
    
    func createLines(lineAmount: Int){
        for line in lines{
            line.removeFromParent()
        }
        lines.removeAll()
        let lineShift = CGFloat(lineAmount - 1) / 2
        
        for line in 0..<lineAmount{
            let shiftedLine = CGFloat(line) - lineShift
            let x = self.size.width / CGFloat(lineAmount + 1) * shiftedLine
            
            let lineNode = SKNode()
            lineNode.position = CGPoint(x: x, y: 0)
            
            lines.append(lineNode)
            horizontal?.addChild(lineNode)
        }
    }
    
    override func didMove(to view: SKView) {
        view.isMultipleTouchEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if playing,
                let horizontal = horizontal,
                touch.location(in: horizontal).y.abs < 100 {
                let p1 = touch.location(in: horizontal)
                let line = lines
                    .map { (line: lines.index(of: $0), distance: relativeDistance(between: p1, and: $0.position)) }
                    .sorted { $0.distance<$1.distance }
                    .first?
                    .line
                createNode(line: line ?? 0)
            }
            else{
                let nodes = self.nodes(at: touch.location(in: self))
                if nodes.contains(where: { (node) -> Bool in
                    node.name == "node"
                }){
                    let node = nodes.first(where: { (node) -> Bool in
                        node.name == "node"
                    })
                    draggedNode = node
                    dragNodeLocation = touch.location(in: self)
                    
                    let curtime = CACurrentMediaTime()
                    if let lastTime = firstTapTime, lastTime + 0.5 >= curtime, node == firstTapNode{
                        if let node = node{
                            remove(node: node)
                        }
                    }else{
                        firstTapNode = node
                        firstTapTime = curtime
                    }
                }
                else{
                    dragFieldLocation = touch.location(in: self)
                    if dragCurrentTime == nil{
                        dragCurrentTime = musicPlayerManager.musicPlayerController.currentPlaybackTime
                    }
                }
            }
        }
    }
    
    var firstTapNode: SKNode?
    var firstTapTime: TimeInterval?
    
    var dragFieldLocation: CGPoint?
    var dragNodeLocation: CGPoint?
    var draggedNode : SKNode?
    var dragCurrentTime: TimeInterval?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let cur = touches.first?.location(in: self) else {return}
        if let prev = dragFieldLocation, let time = dragCurrentTime{
            let delta = Double(prev.y - cur.y) / globalSpeed
            dragCurrentTime = time + Double(delta)
            dragFieldLocation = cur
        }
        if let node = draggedNode, let prev = dragNodeLocation{
            let levelNode = node.userData?["levelNode"] as? Node
            let delta = Double(cur.y - prev.y) / globalSpeed * 1000
            levelNode?.time += Int(delta)
            dragNodeLocation = cur
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dragFieldLocation = nil
        dragNodeLocation = nil
        draggedNode = nil
        for touch in touches{
            for node in self.nodes(at: touch.location(in: self)){
                switch node.name{
                case pauseName:
                    if playing{
                        pauseNode?.texture = SKTexture(image: #imageLiteral(resourceName: "play"))
                        dragCurrentTime = musicPlayerManager.musicPlayerController.currentPlaybackTime
                    }else{
                        pauseNode?.texture = SKTexture(image: #imageLiteral(resourceName: "pause"))
                        if let time = dragCurrentTime{
                            musicPlayerManager.musicPlayerController.currentPlaybackTime = time
                        }
                        dragCurrentTime = nil
                    }
                    musicPlayerManager.togglePlayPause()
                    
                case menuName:
                    if playing{
                        musicPlayerManager.togglePlayPause()
                        pauseNode?.run(SKAction.setTexture(SKTexture(image: #imageLiteral(resourceName: "play"))))
                    }
                    blur?.run(SKAction.fadeAlpha(to: 0.5, duration: 0.2))
                    menuScreen?.run(SKAction.fadeIn(withDuration: 0.2))
                    
                case mainMenuName:
                    viewController?.performSegue(withIdentifier: "goToInitial", sender: viewController)
                    
                case closeName:
                    blur?.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
                    menuScreen?.run(SKAction.fadeOut(withDuration: 0.2))
                    
                case refineName:
                    if let level = level{
                        let deleted = LevelRefiner.mergeNodes(level: level)
                        for node in deleted{
                            var done = false
                            for line in lines{
                                for child in line.children{
                                    if child.userData?["levelNode"] as? Node == node{
                                        remove(node: child)
                                        done = true
                                        break
                                    }
                                }
                                if done {
                                    break
                                }
                            }
                        }
                        
                        LevelRefiner.stabilizeNodes(level: level)
                    }
                    
                default:
                    ()
                }
            }
        }
    }
    
    func getCurrentTime()->TimeInterval{
        if !playing, let dragCurrentTime = dragCurrentTime{
            return dragCurrentTime
        }
        return musicPlayerManager.musicPlayerController.currentPlaybackTime
    }
    
    func createNode(line: Int){
        if let node = genericNode?.copy() as? SKShapeNode{
            node.setColor(line: line)
            let time = Int(musicPlayerManager.musicPlayerController.currentPlaybackTime * 1000)
            
            print(time)
            
            let levelNode = Node(line: line, time: time)
            let entity = CreateNode(node: node, levelNode: levelNode, speed: globalSpeed)
            
            level?.nodes.append(levelNode)
            
            entities.append(entity)
            lines[line].addChild(node)
        }
    }
    
    func relativeDistance(between p1: CGPoint, and p2: CGPoint) -> CGFloat{
        return pow(p2.x-p1.x, 2) + pow(p2.y-p1.y, 2)
    }
    
    private var started = false
    override func update(_ currentTime: TimeInterval) {
        let currentTime = getCurrentTime()
        
        updateHorizontals(currentTime)
        updateLabels()
        
        for entity in entities{
            entity.update(deltaTime: currentTime)
        }
    }
    
    func updateHorizontals(_ currentTime: TimeInterval){
        if let duration = musicPlayerManager.musicPlayerController.nowPlayingItem?.playbackDuration,
            !started,
            currentTime<3,
            duration > 0 {
            createHorizontals(duration: duration)
            started = true
        }
    }
    
    func updateLabels(){
        guard let level = level else { return }
        nodeAmount?.text = "\(level.nodes.count)"
        if level.length > 0{
        nodeDensity?.text = String(format: "%.2f", Double(level.nodes.count)/Double(level.length)*1000)
        }else{
            nodeDensity?.text = "0"
        }
    }
}

extension LevelCreateScene{
    func remove(node: SKNode){
        if let entity = node.userData?["entity"] as? GKEntity,
            let index = self.entities.index(of: entity){
            entities.remove(at: index)
        }
        if let levelNode = node.userData?["levelNode"] as? Node,
            let index = self.level?.nodes.index(of: levelNode){
            level?.nodes.remove(at: index)
        }
        node.run(
            SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.2),
                SKAction.removeFromParent()
                ])
        )
    }
    
    func remove(entity: GKEntity){
        if let index = self.entities.index(of: entity){
            entities.remove(at: index)
        }
        if let node = entity.component(ofType: NodeComponent.self)?.node{
            if let levelNode = node.userData?["levelNode"] as? Node,
                let index = self.level?.nodes.index(of: levelNode){
                level?.nodes.remove(at: index)
            }
            node.removeFromParent()
        }
    }
}
