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
    
//    func addRecord(recordDict: Dictionary, type: Object.Type) {
//        
//    }
}
