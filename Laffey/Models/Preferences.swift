//
//  Preferences.swift
//  Laffey
//
//  Created by 戴元平 on 8/15/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import Foundation

fileprivate let userDefaults = UserDefaults(suiteName: "group.works.dd.Laffey")!

public class Preferences {
    public var myself: User {
        get {
            return User(id: self.userID, group_id: self.groupID, role: self.role, username: self.username, nickname: self.nickname)
        }
        set(value) {
            self.userID = value.id
            self.groupID = value.group_id ?? 0
            self.role = value.role
            self.username = value.username
        }
    }
    
    public var username: String {
        get {
            return userDefaults.string(forKey: "username" ) ?? ""
        }
        set(value) {
            userDefaults.set(value, forKey: "username" )
        }
    }
    
    public var email: String {
        get {
            return userDefaults.string(forKey: "email" ) ?? ""
        }
        set(value) {
            userDefaults.set(value, forKey: "email" )
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
    
    public var nickname: String {
        get {
            return userDefaults.string(forKey: "nickname" ) ?? ""
        }
        set(value) {
            userDefaults.set(value, forKey: "nickname" )
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
    
    public var personalRecordLastUpdated: Int {  // 这是一个timestamp
        get {
            return userDefaults.integer(forKey: "personalRecordLastUpdated" )
        }
        set(value) {
            userDefaults.set(value, forKey: "personalRecordLastUpdated" )
        }
    }
    
    public var groupID: Int {  // Defaults to 0
        get {
            return userDefaults.integer(forKey: "groupID" )
        }
        set(value) {
            userDefaults.set(value, forKey: "groupID" )
        }
    }
    
    public var role: Int {
        get {
            return userDefaults.integer(forKey: "role" )
        }
        set(value) {
            userDefaults.set(value, forKey: "role" )
        }
    }
    
    public var userID: Int {
        get {
            return userDefaults.integer(forKey: "userID")
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
    
    public var didEnablePN: Bool {
        get {
            return userDefaults.bool(forKey: "didEnablePN" )
        }
        set (value) {
            userDefaults.set(value, forKey: "didEnablePN" )
        }
    }
    
    public var didPromptPN: Bool {
        get {
            return userDefaults.bool(forKey: "didPromptPN" )
        }
        set (value) {
            userDefaults.set(value, forKey: "didPromptPN" )
        }
    }
}
