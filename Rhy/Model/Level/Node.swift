//
//  Node.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 25.02.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation

class Node : Codable, Equatable{
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.line == rhs.line && lhs.type == rhs.type && lhs.time == rhs.time
    }
    
    enum NodeType : String, Codable{
        case tap = "tap"
        case hold = "hold"
//        case swipe
//        case holdswipe
    }
    var line: Int = 0
    var type: NodeType = .tap
    var time: Int = 0
    var times: [Int] = []
    
    init(line: Int, time: Int, type: NodeType = .tap, times: [Int] = []){
        self.line = line
        self.time = time
        self.type = type
        self.times = times
    }
}
