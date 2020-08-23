//
//  Shared.swift
//  Laffey
//
//  Created by 戴元平 on 8/15/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

class Shared: ObservableObject {
    @Published var didlogin: Bool
    @Published var didJoinGroup: Bool
    
    init() {
        didlogin = Preferences().didLogin
        didJoinGroup = Preferences().didJoinGroup
    }
}
