//
//  Dashboard.swift
//  Laffey
//
//  Created by 戴元平 on 8/15/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI
import RealmSwift
import SwiftyJSON

struct Dashboard: View {
    @Environment(\.managedObjectContext) var moc
    @State var recordList: Results<TeamRecord>?
    @ObservedObject var currentRecord: TeamRecordNative = TeamRecordNative()
    @State var isAddingRecord: Bool = false
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                Text("当前攻略")
                    .font(.largeTitle)
                
                VStack {
                    HStack {
                        Text(String(currentRecord.current_boss_gen))
                        Text("周目")
                    }
                    HStack {
                        Text(String(currentRecord.current_boss_order))
                            .font(.largeTitle)
                            .foregroundColor(Color.salmon)
                        Text("王")
                            .font(.largeTitle)
                            .foregroundColor(Color.salmon)
                    }
                }
                
                Text("剩余血量：" + String(currentRecord.boss_remaining_health))
                ProgressBar(value: $currentRecord.boss_health_percentage)
                    .frame(minHeight: 30)
                    .padding()
                    .transition(.identity)
                    .animation(.none)
                
                Button(action: {
                    withAnimation {
                        self.isAddingRecord = true
                    }
                }) {
                    Text("报刀")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                }
                .font(.headline)
                .background(Color.salmon)
                .foregroundColor(.white)
                .cornerRadius(40)
                .padding(30)
                .animation(.none)
                
                if isAddingRecord {
                    AddRecordView(recordForm:
                        RecordForm(
                            boss_gen: String(Int(currentRecord.current_boss_gen)),
                            boss_order: Int(currentRecord.current_boss_order) - 1
                    ), isAddingRecord: $isAddingRecord,
                       currentRecord: currentRecord)
                }
            }
        }
        .keyboardResponsive()
        .onAppear() {
            self.fetchAllRecords()
        }
        .onReceive(timer) { _ in
            self.fetchAllRecords()
        }
    }
    
    func fetchAllRecords() {
        provider.request(.getRecords(updatedSince: "0", type: "team")) { (result) in
            switch result {
            case let .success(response):
                print(String(data: response.data, encoding: .utf8) ?? "")
                if let json = try? JSON(data: response.data) {
                    let realm = try! Realm()
                    for record in json["data"].arrayValue {
                        if let dictRow = record.dictionaryObject {
                            try! realm.write {
                                realm.add(TeamRecord(value: dictRow), update: .modified)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.refreshData()
                    }
                }
            case let .failure(error):
                self.displayError(message: error.localizedDescription)
            }
        }
    }
    
    func refreshData() {
        let realm = try! Realm()
        self.recordList = realm.objects(TeamRecord.self).sorted(byKeyPath: "detail_date", ascending: false)
        if (self.recordList?.count ?? 0) > 0 {
            self.currentRecord.update(teamRecord: recordList![0])
        }
    }
    
    func displayError(message: String) {
        
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(isAddingRecord: true)
    }
}
