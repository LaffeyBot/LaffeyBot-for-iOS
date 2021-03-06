//
//  RecordForm.swift
//  Laffey
//
//  Created by 戴元平 on 8/16/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import Foundation

class RecordForm {
    var id: Int?
    var damage: String = "0"
    var type_index: Int = 0
    var boss_gen: String = "1"
    var boss_order: Int = 1
    var user: User = Preferences().myself
    var type: String {
        get {
            switch type_index {
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
    
    init(boss_gen: String, boss_order: Int) {
        self.boss_gen = boss_gen
        self.boss_order = boss_order
    }
    
    init(record: PersonalRecord) {
        self.id = Int(record.id)
        self.damage = String(record.damage)
        self.boss_gen = String(record.boss_gen)
        self.boss_order = Int(record.boss_order)
        self.user = Preferences().myself  // 这个不会被用到
        var type_index: Int {
            switch record.type {
            case "normal":
                return 0
            case "last":
                return 1
            case "compensation":
                return 2
            default:
                return 0
            }
        }
        self.type_index = type_index
    }
    
    init() {
    }
}
