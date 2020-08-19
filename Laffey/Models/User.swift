//
//  User.swift
//  Laffey
//
//  Created by 戴元平 on 8/17/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

public class User: Codable, Identifiable {
    var id: Int
    var group_id: Int?
    var role: Int
    var username: String
    var nickname: String
    
    init(id: Int, group_id: Int?, role: Int, username: String,
         nickname: String) {
        self.id = id
        self.group_id = group_id
        self.role = role
        self.username = username
        self.nickname = nickname
    }
}
