//
//  LevelSelectWorker.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 24.03.2018.
//  Copyright (c) 2018 Roman Abuzyarov. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class LevelSelectWorker
{
    private var dataManager: DataManager = ParseDataManager()
    func loadLevels(for id: String, onSuccess: @escaping ([Level])->Void)
    {
        dataManager.loadLevels(for: id, onSuccess: onSuccess)
    }
}
