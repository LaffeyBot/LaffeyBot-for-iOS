//
//  RegisterResponse.swift
//  Laffey
//
//  Created by DDavid on 8/15/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import Foundation

struct RegisterResponse: Codable {
    let msg: String
    let id: Int
    let jwt: String
}
