//
//  RealmDatabase.swift
//  Laffey
//
//  Created by 戴元平 on 8/17/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmDatabase {
    let realm = try! Realm()
    
    func addRecord(record: Object) {
        try! realm.write {
            realm.add(record, update: .modified)
        }
    }
    
    func getAllPersonalRecords() -> Results<PersonalRecord> {
        return realm.objects(PersonalRecord.self).sorted(byKeyPath: "detail_date", ascending: false)
    }
    
    func getCurrentTeamRecord(current: TeamRecordNative) -> TeamRecordNative {
        let realm = try! Realm()
        let recordList = realm.objects(TeamRecord.self).sorted(byKeyPath: "detail_date", ascending: false)
        if recordList.count > 0 {
            current.update(teamRecord: recordList[0])
            return current
        } else {
            return TeamRecordNative()
        }
    }
    
//    func addRecord(recordDict: Dictionary, type: Object.Type) {
//        
//    }
}
