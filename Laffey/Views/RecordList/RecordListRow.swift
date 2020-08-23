//
//  RecordListRow.swift
//  Laffey
//
//  Created by 戴元平 on 8/15/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI
import RealmSwift

struct RecordListRow: View {
    var record: PersonalRecord
    let userID = Preferences().userID
    @State var alert = Alert(title: Text(""))
    @State var doShowAlert = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(record.nickname)
                    Text("对")
                }
                
                HStack {
                    Text(String(record.boss_gen))
                    Text("周目")
                    Text(String(record.boss_order))
                    Text("王")
                }
                
                HStack {
                    Text("造成了")
                    Text(String(record.damage))
                        .foregroundColor(Color.salmon)
                    Text("点伤害")
                }
            }
            .frame(alignment: .leading)
            .alert(isPresented: $doShowAlert, content: {
                alert
            })
            
            Spacer()
            
            if record.user_id == userID {
                VStack(alignment: .trailing) {
                    Button(action: {
                        self.modifyRecord()
                    }) {
                        Text("修改")
                            .frame(minWidth: 0, maxWidth: 60, minHeight: 30, maxHeight: 50)
                    }
                    .font(.headline)
                    .background(Color.salmon)
                    .foregroundColor(.white)
                    .cornerRadius(40)
                    .padding([[.vertical]], 5)
                    
                    Button(action: {
                        
                    }) {
                        Text("删除")
                            .frame(minWidth: 0, maxWidth: 60, minHeight: 30, maxHeight: 50)
                    }
                    .font(.headline)
                    .background(Color.white)
                    .foregroundColor(Color.red)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.red, lineWidth: 2)
                    )
                    .padding([[.vertical]], 0)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
    
    func deleteRecord() {
        provider.request(.deleteRecord(id: Int(record.id))) { result in
            switch result {
            case let .failure(error):
                self.showMessage(title: "错误", message: error.localizedDescription)
            case let .success(response):
                if response.statusCode == 200 {
                    self.showMessage(title: "成功", message: "已删除本记录")
                    let realm = try! Realm()
                    let self_record = realm.objects(PersonalRecord.self)
                        .filter("id = \(String(record.id))}")
                    try! realm.write {
                        realm.delete(self_record)
                    }
                } else {
                    self.showMessage(title: "错误", message: "未知错误")
                }
            }
        }
    }
    
    func showMessage(title: String, message: String) {
        alert = Alert(title: Text(title), message: Text(message))
        self.doShowAlert = true
    }
    
    func modifyRecord() {
        
    }
}

struct RecordListRow_Previews: PreviewProvider {
    static var previews: some View {
        RecordListRow(record: PersonalRecord())
    }
}
