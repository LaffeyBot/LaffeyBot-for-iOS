//
//  LoginResponse.swift
//  Laffey
//
//  Created by 戴元平 on 8/15/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let msg: String
    let jwt: String
    let id: Int
}
