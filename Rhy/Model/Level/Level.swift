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
        }
    }
    var songId: String
    var author: String?
}
