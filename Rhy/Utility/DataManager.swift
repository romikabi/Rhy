//
//  LevelDataManager.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 24.03.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation
import Parse

protocol DataManager {
    func save(level: Level, for id: String)
    func loadLevels(for id: String, onSuccess: @escaping ([Level]) -> Void)
}

//class LocalDataManager {
//
//    private static var ud = UserDefaults.standard
//
//    static func save(level: Level, for id: String) {
//
//        var levels = ud.stringArray(forKey: id) ?? []
//        do {
//            if let string = String(data: try JSONEncoder().encode(level), encoding: .utf8) {
//                levels.append(string)
//            }
//        } catch {}
//
//        ud.set(levels, forKey: id)
//    }
//
//    static func loadLevels(for id: String) -> [Level] {
//        let decoder = JSONDecoder()
//        do {
//            return try (ud.stringArray(forKey: id) ?? []).map {
//                try decoder.decode(Level.self, from: $0.data(using: .utf8)!)
//            }
//        } catch {
//            print("error while decoding level")
//            return []
//        }
//    }
//}

class ParseDataManager: DataManager {
    func save(level: Level, for id: String) {
        let pfo = PFObject(className: "Level")
        pfo["title"] = level.title
        pfo["lines"] = level.lines
        pfo["songId"] = id
        pfo["length"] = level.length

        let je = JSONEncoder()
        let nodes = level.nodes
                .map { try? je.encode($0) }
                .filter { $0 != nil }
                .map { String(data: $0!, encoding: .utf8) }
                .filter { $0 != nil }
                .map { $0! }
        pfo["nodes"] = nodes

        pfo["author"] = level.author
        pfo["star"] = level.star
        pfo["rating"] = level.rating
        pfo["ratingCount"] = level.ratingCount
        pfo["authorId"] = level.authorId
        pfo["speed"] = level.speed

        pfo.saveInBackground()
    }

    func loadLevels(for id: String, onSuccess: @escaping ([Level]) -> Void) {
        PFQuery(className: "Level")
                .whereKey("songId", equalTo: id)
                .findObjectsInBackground { (pfos, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }

                    guard let pfos = pfos else { return }
                    var levels = [Level]()
                    for pfo in pfos {
                        let title = pfo["title"] as? String ?? ""
                        let lines = pfo["lines"] as? Int ?? 0
                        let songId = pfo["songId"] as? String ?? ""
                        let length = pfo["length"] as? Int ?? 0

                        let jd = JSONDecoder()
                        let nilNodes = (pfo["nodes"] as? [String] ?? []).map { try? jd.decode(Node.self, from: $0.data(using: .utf8)!) }
                        let nodes = nilNodes.filter { $0 != nil }.map { $0! }

                        let author = pfo["author"] as? String ?? ""
                        let star = pfo["star"] as? Bool ?? false
                        let rating = pfo["rating"] as? Double ?? 0.0
                        let ratingCount = pfo["ratingCount"] as? Int ?? 0
                        let authorId = pfo["authorId"] as? String ?? ""
                        let speed = pfo["speed"] as? Int ?? 500

                        let level = Level(title: title, lines: lines, songId: songId, length: length, nodes: nodes, author: author, star: star, rating: rating, ratingCount: ratingCount, authorId: authorId, speed: speed)
                        level.pfo = pfo
                        levels.append(level)
                    }

                    levels.sort(by: { (l1, l2) -> Bool in
                        if l1.star != l2.star {
                            return l1.star
                        } else {
                            return l1.rating > l2.rating
                        }
                    })

                    onSuccess(levels)
                }
    }
}
