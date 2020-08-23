//
//  TeamRank.swift
//  Laffey
//
//  Created by 戴元平 on 8/23/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import RealmSwift

class TeamRank: Object {
    @objc dynamic var id: Int32 = 0
    @objc dynamic var epoch_id: Int32 = 0
    @objc dynamic var group_id: Int32 = 0
    @objc dynamic var total_score: Int64 = 0
    @objc dynamic var record_date: Int32 = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
