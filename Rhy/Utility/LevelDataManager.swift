//
//  LevelDataManager.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 24.03.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation

class LevelDataManager{
    
    private static var ud = UserDefaults.standard
    
    static func save(level: Level, for id: String){
        
        var levels = ud.stringArray(forKey: id) ?? []
        do{
            if let string = String(data: try JSONEncoder().encode(level), encoding: .utf8){
                levels.append(string)
            }
        } catch{ }
        
        ud.set(levels, forKey: id)
    }
    
    static func loadLevels(for id: String) -> [Level]{
        let decoder = JSONDecoder()
        do
        {
            return try (ud.stringArray(forKey: id) ?? []).flatMap {
                try decoder.decode(Level.self, from: $0.data(using: .utf8)!)
            }
        } catch{ return [] }
    }
}
