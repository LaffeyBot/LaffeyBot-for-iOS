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
    let myself = Preferences().myself
    let userID = Preferences().userID
    @State var alert = Alert(title: Text(""))
    @State var doShowAlert = false
    @State var isEditing = false
    @State var recordForm: RecordForm = RecordForm()
    
    var body: some View {
        VStack {
            if isEditing {
                AddRecordView(recordForm: RecordForm(record: record),
                              isAddingRecord: $isEditing,
                              currentRecord: RealmDatabase().getCurrentTeamRecord(current: TeamRecordNative()),
                              isModifying: true)
            } else {
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
                    
                    if record.user_id == userID || myself.role > 0  {
                        VStack(alignment: .trailing) {
                            Button(action: {
                                withAnimation {
                                    self.isEditing.toggle()
                                }
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
                                self.confirmDeletion()
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
        }
    }
    
    func confirmDeletion() {
        alert = Alert(title: Text("删除记录"),
                      message: Text("你确定要删除这条记录吗？"),
                      primaryButton: .destructive(Text("删除"), action: {
                        self.deleteRecord()
                      }), secondaryButton: .cancel())
        self.doShowAlert.toggle()
    }
    
    func deleteRecord() {
        provider.request(.deleteRecord(id: Int(record.id))) { result in
            switch result {
            case let .failure(error):
                self.showMessage(title: "错误", message: error.localizedDescription)
            case let .success(response):
                if response.statusCode == 200 {
                    self.showMessage(title: "成功", message: "已删除本记录")
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
}

struct RecordListRow_Previews: PreviewProvider {
    static var previews: some View {
        RecordListRow(record: PersonalRecord())
    }
}
