//
//  TeamRecord.swift
//  Laffey
//
//  Created by 戴元平 on 8/16/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI
import RealmSwift


class TeamRecord: Object, Codable {
    @objc dynamic var id: Int32 = 0
    @objc dynamic var record: Int32 = 0
    @objc dynamic var detail_date: Int32 = 0
    @objc dynamic var epoch_id: Int32 = 0
    @objc dynamic var group_id: Int32 = 0
    @objc dynamic var current_boss_gen: Int32 = 0
    @objc dynamic var current_boss_order: Int32 = 0
    @objc dynamic var boss_remaining_health: Int32 = 0
    @objc dynamic var last_modified: Int32 = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class TeamRecordNative: ObservableObject {
    @Published var id: Int32 = 0
    @Published var record: Int32 = 0
    @Published var detail_date: Int32 = 0
    @Published var epoch_id: Int32 = 0
    @Published var group_id: Int32 = 0
    @Published var current_boss_gen: Int32 = 0
    @Published var current_boss_order: Int32 = 0
    @Published var boss_remaining_health: Int32 = 0
    @Published var last_modified: Int32 = 0
    @Published var boss_health_percentage: Float = 1.0
    
    func update(teamRecord: TeamRecord) {
        self.boss_remaining_health = teamRecord.boss_remaining_health
        self.id = teamRecord.id
        self.detail_date = teamRecord.detail_date
        self.epoch_id = teamRecord.epoch_id
        self.group_id = teamRecord.group_id
        self.current_boss_gen = teamRecord.current_boss_gen
        self.current_boss_order = teamRecord.current_boss_order
        self.boss_remaining_health = teamRecord.boss_remaining_health
        self.last_modified = teamRecord.last_modified
        if self.current_boss_order != 0 {
            self.boss_health_percentage = Float(self.boss_remaining_health) / Float(bossMaxHealth[Int(current_boss_order) - 1])
        }
       
    }
}

