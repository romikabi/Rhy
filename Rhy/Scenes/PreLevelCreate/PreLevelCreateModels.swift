//
//  PreLevelCreateModels.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 03.04.2018.
//  Copyright (c) 2018 Roman Abuzyarov. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum PreLevelCreate
{
    // MARK: Use cases
    
    enum FillDataStore
    {
        struct Request
        {
            var levelName: String
            var linesCount: Int
            var speed: Int
        }
        struct Response
        {
        }
        struct ViewModel
        {
        }
    }
}
