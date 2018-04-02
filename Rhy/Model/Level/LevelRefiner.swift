//
//  LevelRefiner.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 02.04.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation

class LevelRefiner{
    
    static func mergeNodes(level: Level) -> [Node]{
        level.nodes.sort {$0.time<$1.time}
        var nodesToBeDeleted = [Node]()
        var index = 0
        while index < level.nodes.count{
            defer {
                index+=1
            }
            let node = level.nodes[index]
            var timeNodes = [Node]()
            for node2 in level.nodes[(index+1)...]{
                if node2.time < node.time + 100 && node2.line == node.line{
                    timeNodes.append(node2)
                }
                else{
                    break
                }
            }
            if timeNodes.count == 0{
                continue
            }
            let syncTime = (timeNodes.reduce(0) { $0+$1.time } + node.time) / (timeNodes.count+1)
            for node2 in timeNodes{
                if let node2index = level.nodes.index(of: node2){
                    level.nodes.remove(at: node2index)
                    nodesToBeDeleted.append(node2)
                }
            }
            node.time = syncTime
            
        }
        return nodesToBeDeleted
    }
    
    static func stabilizeNodes(level: Level){
        level.nodes.sort {$0.time<$1.time}
        var index = 0
        while index < level.nodes.count{
            defer{
                index+=1
            }
            let node = level.nodes[index]
            var timeNodes = [Node]()
            for node2 in level.nodes[(index+1)...]{
                if node2.time < node.time + 100 && node2.line != node.line{
                    timeNodes.append(node2)
                }
                else{
                    break
                }
            }
            if timeNodes.count == 0{
                continue
            }
            
            let syncTime = (timeNodes.reduce(0) { $0+$1.time } + node.time) / (timeNodes.count+1)
            for node2 in timeNodes{
                node2.time = syncTime
            }
            node.time = syncTime
            
            index+=1
        }
    }
}
