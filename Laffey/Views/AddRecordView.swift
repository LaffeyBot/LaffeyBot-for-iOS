//
//  AddRecordView.swift
//  Laffey
//
//  Created by 戴元平 on 8/16/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

struct AddRecordView: View {
    @Binding var currentRecord: TeamRecordNative
    @State var recordForm: RecordForm = RecordForm()
    @State var isShowingMore: Bool = false
    
    var body: some View {
        VStack {
            Picker(selection: $recordForm.typeIndex, label: Text("出刀类型")) {
                Text("普通").tag(0)
                Text("尾刀").tag(1)
                Text("补偿刀").tag(2)
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
            
            HStack {
                Text("伤害")
                TextField("伤害", value: $recordForm.damage, formatter: NumberFormatter())
                    .padding(.horizontal, 30)
                    .transition(.opacity)
                    .keyboardType(.numberPad)
                Divider()
                    .padding([.leading, .trailing], 30)
                    .transition(.opacity)
            }
            
            
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
                .padding()
            }
        }
    }
}

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView(currentRecord: .constant(TeamRecordNative()))
    }
}
