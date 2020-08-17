//
//  RecordListView.swift
//  Laffey
//
//  Created by 戴元平 on 8/17/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI
import RealmSwift

struct RecordListView: View {
    @State var recordList: Results<PersonalRecord> = RealmDatabase().getAllPersonalRecords()
    var body: some View {
        NavigationView {
            List {
                ForEach(recordList, id: \.id) { record in
                    RecordListRow(record: record)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            
        .navigationBarTitle("出刀记录")
        }
        .onAppear() {
            self.fetchAllRecords()
        }
    }
    
    func fetchAllRecords() {
        FetchData().fetchAllPersonalRecords { result in
            switch result {
            case .success:
                self.refreshData()
            case let .error(error):
                self.displayErrorMessage(msg: error.localizedDescription)
            case .noUpdate:
                break
            }
        }
    }
    
    func displayErrorMessage(msg: String) {
        
    }
    
    func refreshData() {
        let realm = try! Realm()
        recordList = realm.objects(PersonalRecord.self).sorted(byKeyPath: "detail_date", ascending: false)
    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView()
    }
}
