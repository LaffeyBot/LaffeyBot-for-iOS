//
//  GetMemberResponse.swift
//  Laffey
//
//  Created by 戴元平 on 8/18/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

struct GetMemberResponse: Codable {
    let data: [User]
    let msg: String
}
