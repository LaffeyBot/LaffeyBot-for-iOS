//
//  AddRecordView.swift
//  Laffey
//
//  Created by 戴元平 on 8/16/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI
import RealmSwift
import SwiftyJSON

struct AddRecordView: View {
    @State var recordForm: RecordForm = RecordForm()
    @State var isShowingMore: Bool = false
    @Binding var isAddingRecord: Bool
    @ObservedObject var currentRecord: TeamRecordNative
    @State var doShowMemberSelector: Bool = false
    @State var isSubmitting: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            Picker(selection: $recordForm.type_index.onChange(onTypeIndexChange), label: Text("出刀类型")) {
                Text("普通").tag(0)
                Text("尾刀").tag(1)
                Text("补偿刀").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
            
            HStack {
                Text("伤害")
                VStack {
                    TextField("伤害", text: $recordForm.damage)
                        .padding(.horizontal, 30)
                        .keyboardType(.numberPad)
                    Divider()
                        .padding([.leading, .trailing], 30)
                }
                
            }
            .padding()
            
            if !isShowingMore {
                Button(action: {
                    withAnimation {
                        self.isShowingMore.toggle()
                    }
                }) {
                    Text("显示更多选项")
                        .transition(.opacity)
                        .foregroundColor(Color.salmon)
                }
            } else {
                HStack {
                    Text("周目")
                    VStack {
                        TextField("周目", text: $recordForm.boss_gen)
                            .padding(.horizontal, 30)
                            .keyboardType(.numberPad)
                        Divider()
                            .padding([.leading, .trailing], 30)
                    }
                    
                }
                .padding()
                
                HStack {
                    Text("第")
                    Picker(selection: $recordForm.boss_order, label: Text("")) {
                        Text("1").tag(0)
                        Text("2").tag(1)
                        Text("3").tag(2)
                        Text("4").tag(3)
                        Text("5").tag(4)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    Text("王")
                    
                }
                .padding(.horizontal, 30)
                
                HStack {
                    Text("出刀玩家：")
                    .padding(.leading, 30)
                    Text(recordForm.user.nickname)
                    Spacer()
                    Button(action: {
                        self.doShowMemberSelector.toggle()
                    }, label: {
                        Text("修改")
                    })
                    .foregroundColor(.salmon)
                    .padding(.horizontal, 30)
                    .sheet(isPresented: $doShowMemberSelector) {
                        MemberSelector(selectedMemeber: $recordForm.user, doShowMemberSelector: self.$doShowMemberSelector)
                    }
                }
            }
            
            HStack {
                Button(action: {
                    self.isSubmitting = true
                    self.submitRecord()
                }) {
                    if !isSubmitting {
                        Text("提交")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    } else {
                        ActivityIndicatorView(isAnimating: .constant(true), style: .medium, color: UIColor.white)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    }
                    
                }
                .font(.headline)
                .background(Color.salmon)
                .foregroundColor(.white)
                .cornerRadius(40)
                .padding([.horizontal], 20)
                
                Button(action: {
                    withAnimation {
                        self.isAddingRecord = false
                    }
                }) {
                    Text("取消")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                }
                .font(.headline)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(40)
                .padding([.horizontal], 20)
            }
        }
    }
    
    func onTypeIndexChange(typeIndex: Int) {
        if typeIndex == 1 {
            self.recordForm.damage = String(currentRecord.boss_remaining_health)
        }
    }
    
    func displayErrorMessage(msg: String) {
        
    }
    
    func submitRecord() {
        if Int(recordForm.boss_gen) == nil {
            self.displayErrorMessage(msg: "boss代数不是整数喵...")
        }
        
        provider.request(.addRecord(recordForm: recordForm)) { result in
            switch result {
            case let .success(response):
                print(String(data: response.request?.httpBody ?? Data(), encoding: .utf8))
                print(String(data: response.data, encoding: .utf8))
                if let json = try? JSON(data: response.data) {
                    let realm = RealmDatabase()
                    if let dictRow = json["team_record"].dictionaryObject {
                        let recordToAdd = TeamRecord(value: dictRow)
                        realm.addRecord(record: recordToAdd)
                        
                        DispatchQueue.main.async {
                            self.currentRecord.update(teamRecord: recordToAdd)
                            self.isAddingRecord = false
                            self.isSubmitting = false
                        }
                    }
                }
            case let .failure(error):
                self.displayErrorMessage(msg: error.localizedDescription)
            }
        }
    }
}

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView(recordForm: RecordForm(), isShowingMore: true, isAddingRecord: .constant(false), currentRecord: TeamRecordNative())
    }
}
