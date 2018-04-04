//
//  Level.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 25.02.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation

class Level : Codable{
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
    
    init(title: String,
         lines: Int,
         songId: String,
         length: Int = 0,
         nodes: [Node] = [],
         author: String = "",
         star: Bool = false,
         rating: Double = 0,
         ratingCount: Int = 0,
         authorId: String = ""){
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
    }
}
