//
//  PersonalRecord.swift
//  Laffey
//
//  Created by 戴元平 on 8/17/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import Foundation
import RealmSwift

class PersonalRecord: Object {
    @objc dynamic var id: Int32 = 0
    @objc dynamic var damage: Int32 = 0
    @objc dynamic var score: Int32 = 0
    @objc dynamic var type: String = ""
    @objc dynamic var nick_name: String = ""
    @objc dynamic var detail_date: Int32 = 0
    @objc dynamic var user_id: Int32 = 0
    @objc dynamic var epoch_id: Int32 = 0
    @objc dynamic var group_id: Int32 = 0
    @objc dynamic var boss_gen: Int32 = 0
    @objc dynamic var boss_order: Int32 = 0
    @objc dynamic var boss_remaining_health: Int32 = 0
    @objc dynamic var last_modified: Int32 = 0
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
