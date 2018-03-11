//
//  GameViewController.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 22.02.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                var level: Level? = nil
                do{
                    level = try JSONDecoder().decode(Level.self, from: try """
{
  "title": "Example level",
  "song": "Some hyperlink",
  "author": "Some id",
  "lines": 3,
  "length": 10000,
  "nodes": [
    {
      "type": "tap",
      "line": 2,
      "time": 900,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 1210,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 1610,
      "times": []
    },
    {
      "type": "tap",
      "line": 1,
      "time": 1780,
      "times": []
    },
    {
      "type": "tap",
      "line": 2,
      "time": 1940,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 2290,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 2630,
      "times": []
    },
    {
      "type": "tap",
      "line": 1,
      "time": 2790,
      "times": []
    },
    {
      "type": "tap",
      "line": 2,
      "time": 2970,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 3310,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 3630,
      "times": []
    },
    {
      "type": "tap",
      "line": 1,
      "time": 3790,
      "times": []
    },
    {
      "type": "tap",
      "line": 2,
      "time": 3950,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 4290,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 4610,
      "times": []
    },
    {
      "type": "tap",
      "line": 1,
      "time": 4780,
      "times": []
    },
    {
      "type": "tap",
      "line": 2,
      "time": 4940,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 5260,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 5600,
      "times": []
    },
    {
      "type": "tap",
      "line": 1,
      "time": 5760,
      "times": []
    },
    {
      "type": "tap",
      "line": 2,
      "time": 5940,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 6260,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 6570,
      "times": []
    },
    {
      "type": "tap",
      "line": 1,
      "time": 6750,
      "times": []
    },
    {
      "type": "tap",
      "line": 2,
      "time": 6910,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 7240,
      "times": []
    },
    {
      "type": "tap",
      "line": 0,
      "time": 7550,
      "times": []
    },
    {
      "type": "tap",
      "line": 1,
      "time": 7700,
      "times": []
    },
    {
      "type": "tap",
      "line": 2,
      "time": 7870,
      "times": []
    },
    {
      "type": "tap",
      "line": 2,
      "time": 8200,
      "times": []
    },
    {
      "type": "tap",
      "line": 2,
      "time": 8560,
      "times": []
    },
    {
      "type": "tap",
      "line": 2,
      "time": 9010,
      "times": []
    }
  ]
}
""".data(using: .utf8)!)
                }catch{}
                
                if let level = level{
                    sceneNode.initiate(with: level, song: "todo")
                }
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
