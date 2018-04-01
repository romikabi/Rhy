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
    
    private var horizontal : SKSpriteNode?
    
    private let pauseName = "pause"
    private let forwardName = "forward"
    private let backwardName = "backward"
    
    private var songId : String?
    
    override func sceneDidLoad() {
        
    }
    
    func initiate(song id: String){
        songId = id
    }
    
    override func didMove(to view: SKView) {
        view.isMultipleTouchEnabled = true
    }
    
    
}
