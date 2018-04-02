//
//  Timeable.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 01.04.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation

protocol Timeable{
    var timeInterval: TimeInterval { get set }
}

extension Node: Timeable{
    var timeInterval: TimeInterval {
        get {
            return Double(time)/1000
        }
        set {
            time = Int(newValue*1000)
        }
    }
}

class LineNode : Timeable{
    var timeInterval: TimeInterval = 0
}
