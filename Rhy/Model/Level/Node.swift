//
//  Node.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 25.02.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation

class Node : Codable{
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
}
