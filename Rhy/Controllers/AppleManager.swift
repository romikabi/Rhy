//
//  AppleManager.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 09.03.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation

class AppleManager{
    var appleMusicManager: AppleMusicManager
    var authorizationManager: AuthorizationManager
    
    private init(){
        appleMusicManager = AppleMusicManager()
        authorizationManager = AuthorizationManager(appleMusicManager: appleMusicManager)
    }
    private static var ins: AppleManager?
    static var instance: AppleManager{
        get{
            if ins == nil{
                ins = AppleManager()
            }
            return ins!
        }
    }
}
