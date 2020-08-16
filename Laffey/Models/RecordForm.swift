//
//  RecordForm.swift
//  Laffey
//
//  Created by 戴元平 on 8/16/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import Foundation

class RecordForm {
    var damage: Int = 0
    var typeIndex: Int = 0
    var type: String {
        get {
            switch typeIndex {
            case 0:
                return "normal"
            case 1:
                return "last"
            case 2:
                return "compensation"
            default:
                return "normal"
            }
        }
    }
}
