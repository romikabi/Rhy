//
//  Level.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 25.02.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation
import Parse

class Level {
    var title: String
    var lines: Int
    var length: Int //millis
    var nodes: [Node]{
        didSet{
            nodes.sort { $0.time < $1.time }
            length = (nodes.last?.time ?? 0) + 1000
        }
    }
    var songId: String
    var author: String
    var star: Bool
    var rating: Double
    var ratingCount: Int
    var authorId: String
    var speed: Int
    
    var pfo: PFObject?
    
    init(title: String,
         lines: Int,
         songId: String,
         length: Int = 0,
         nodes: [Node] = [],
         author: String = "",
         star: Bool = false,
         rating: Double = 0,
         ratingCount: Int = 0,
         authorId: String = "",
         speed: Int = 500){
        self.title = title
        self.lines = lines
        self.songId = songId
        self.length = length
        self.nodes = nodes
        
        self.author = author
        self.star = star
        self.rating = rating
        self.ratingCount = ratingCount
        self.authorId = authorId
        self.speed = speed
    }
    
    func rate(ofFive: Int){
        pfo?.fetchIfNeededInBackground(block: { (pfo, er) in
            if let er = er{
                print(er.localizedDescription)
                return
            }
            guard let pfo = pfo else {return}
            let r = pfo["rating"] as? Double ?? 0
            let c = pfo["ratingCount"] as? Int ?? 0
            pfo["rating"] = (r*Double(c) + Double(ofFive*20))/Double(c+1)
            pfo["ratingCount"] = c+1
            pfo.saveInBackground()
        })
    }
}
