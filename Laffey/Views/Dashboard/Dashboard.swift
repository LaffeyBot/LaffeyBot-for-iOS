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
    @ObservedObject var currentRecord: TeamRecordNative = RealmDatabase().getCurrentTeamRecord(current: TeamRecordNative())
    @State var isAddingRecord: Bool = false
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    @State var hasError = false
    @State var errorText = ""
    
    @State var doPresentPNPrompt = !Preferences().didPromptPN
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                Text("当前攻略")
                    .font(.largeTitle)
                    .sheet(isPresented: $doPresentPNPrompt, content: {
                        PNPromptView(doPresentPNPrompt: $doPresentPNPrompt)
                    })
                
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
                
                if hasError {
                    Text("错误：" + self.errorText)
                        .foregroundColor(.red)
                }
                
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
            .keyboardResponsive()
        }
        .onAppear() {
            print("DASHBOARD IS VISIBLE")
            if Preferences().didEnablePN {
                XGPush.defaultManager().setBadge(0)
            }
            self.fetchAllRecords()
        }
        .onReceive(timer) { _ in
            self.fetchAllRecords()
        }
    }
    
    func fetchAllRecords() {
        FetchData().fetchAllTeamRecords { (response) in
            switch response {
            case .success:
                DispatchQueue.main.async {
                    self.refreshData()
                    self.hasError = false
                }
            case let .error(error):
                self.displayError(message: error.localizedDescription)
            case .noUpdate:
                self.hasError = false
                break
            }
        }
    }
    
    func refreshData() {
        let realm = try! Realm()
        self.recordList = realm.objects(TeamRecord.self).sorted(byKeyPath: "detail_date", ascending: false)
        if (self.recordList?.count ?? 0) > 0 {
            return currentRecord.update(teamRecord: recordList![0])
        }
    }
    
    func displayError(message: String) {
        withAnimation {
            self.errorText = message
            self.hasError = true
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(isAddingRecord: true)
    }
}
