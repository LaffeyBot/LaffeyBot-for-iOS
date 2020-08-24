//
//  RefreshData.swift
//  Laffey
//
//  Created by 戴元平 on 8/17/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


enum FetchDataResponseType {
    case success
    case error(error: Error)
    case noUpdate
}

enum GetMembersResponseType {
    case success(data: [User])
    case error(error: Error)
}

enum GetBossStatusResponseType {
    case success(data: TeamRecord)
    case error(error: Error)
}

struct FetchData {
    func fetchCurrentBossStatus(completion: @escaping (GetBossStatusResponseType) -> Void) {
        provider.request(.getCurrentBossStatus) { (result) in
            switch result {
            case let .success(response):
                guard let json = try? JSONDecoder().decode(GetCurrentStatusResponse.self, from: response.data) else {
                    print(String(data: response.data, encoding: .utf8) ?? "")
                    return
                }
                
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(realm.objects(TeamRecord.self))
                    realm.add(json.data)
                }
                
                completion(.success(data: json.data))
            case let .failure(error):
                completion(.error(error: error))
            }
        }
    }
    
    func fetchAllTeamRecords(completion: @escaping (FetchDataResponseType) -> Void) {
        provider.request(.getRecords(updatedSince: "0", type: "team")) { (result) in
            switch result {
            case let .success(response):
                guard let json = try? JSON(data: response.data) else {
                    print(String(data: response.data, encoding: .utf8) ?? "")
                    return
                }
                
                let realm = RealmDatabase()
                for record in json["data"].arrayValue {
                    if var dictRow = record.dictionaryObject {
                        if dictRow["record"] as? NSNull == NSNull() || dictRow["record"] == nil {
                            dictRow["record"] = 0
                        }
                        realm.addRecord(record: TeamRecord(value: dictRow))
                    }
                }
                
                completion(.success)
            case let .failure(error):
                completion(.error(error: error))
            }
        }
    }
    
    func fetchAllPersonalRecords(completion: @escaping (FetchDataResponseType) -> Void) {
        provider.request(.getRecords(
            updatedSince: String(Preferences().personalRecordLastUpdated
        ), type: "personal")) { result in
            switch result {
            case let .success(response):
                let statusCode = response.statusCode
                guard statusCode != 304 else {
                    completion(.noUpdate)
                    return
                }
                guard let json = try? JSON(data: response.data) else {
                    print(String(data: response.data, encoding: .utf8) ?? "")
                    return
                }
                
                if let timestamp = json["time"].int {
                    let pref = Preferences()
                    pref.personalRecordLastUpdated = timestamp
                }
                
                let realm = RealmDatabase()
                for record in json["data"].arrayValue {
                    if let dictRow = record.dictionaryObject {
                        realm.addRecord(record: PersonalRecord(value: dictRow))
                    }
                }
                
                self.deleteAllRecordsMatching(deleteds: json["deleted"].arrayValue)
                
                completion(.success)
            case let .failure(error):
                completion(.error(error: error))
            }
        }
    }
    
    func deleteAllRecordsMatching(deleteds: [JSON]) {
        let realm = try! Realm()
        for deleted in deleteds {
            guard let dictRow = deleted.dictionaryObject else {
                continue
            }
            
            let table = dictRow["from_table"] as? String ?? ""
            guard let deleted_id = dictRow["deleted_id"] as? Int else {
                continue
            }
            
            var objectToBeDeleted: Object? = nil
            if table == "PersonalRecord" {
                objectToBeDeleted = realm.objects(PersonalRecord.self).filter("id = \(deleted_id)").first
            } else if table == "TeamRank" {
                objectToBeDeleted = realm.objects(TeamRank.self).filter("id = \(deleted_id)").first
            }
            if objectToBeDeleted != nil && !objectToBeDeleted!.isInvalidated {
                try! realm.write {
                    realm.delete(objectToBeDeleted!)
                }
            }
        }
    }
    
    func getCurrentMembers(completion: @escaping (GetMembersResponseType) -> Void) {
        provider.request(.getMembers) { result in
            switch result {
            case let .success(response):
                print(String(data: response.data, encoding: .utf8))
                if let json = try? JSONDecoder().decode(GetMemberResponse.self, from: response.data) {
                    completion(.success(data: json.data))
                }
            case let .failure(error):
                completion(.error(error: error))
            }
        }
    }
}
