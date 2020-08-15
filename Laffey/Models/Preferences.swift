//
//  Preferences.swift
//  Laffey
//
//  Created by 戴元平 on 8/15/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import Foundation

fileprivate let userDefaults = UserDefaults(suiteName: "group.works.dd.Laffey")!

public struct Preferences {
    public var username: String {
        get {
            return userDefaults.string(forKey: "username" ) ?? ""
        }
        set(value) {
            userDefaults.set(value, forKey: "username" )
        }
    }
    
    public var password: String {
        get {
            return userDefaults.string(forKey: "password" ) ?? ""
        }
        set(value) {
            userDefaults.set(value, forKey: "password" )
        }
    }
    
    public var authToken: String {
        get {
            return userDefaults.string(forKey: "authToken" ) ?? ""
        }
        set(value) {
            userDefaults.set(value, forKey: "authToken" )
        }
    }
    
    public var userID: Int {
        get {
            return userDefaults.string(forKey: "userID" ) ?? -1
        }
        set(value) {
            userDefaults.set(value, forKey: "userID" )
        }
    }
    
    public var didLogin: Bool {
        get {
            return userDefaults.bool(forKey: "didLogin" )
        }
        set (value) {
            userDefaults.set(value, forKey: "didLogin" )
        }
    }
}
