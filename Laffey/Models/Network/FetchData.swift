//
//  RefreshData.swift
//  Laffey
//
//  Created by 戴元平 on 8/17/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import Foundation
import SwiftyJSON

enum FetchDataResponseType {
    case success
    case error(error: Error)
    case noUpdate
}

struct FetchData {
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
                    if let dictRow = record.dictionaryObject {
                        realm.addRecord(record: TeamRecord(value: dictRow))
                    }
                }
                
                completion(.success)
            case let .failure(error):
                completion(.error(error: error))
            }
        }
    }
}
