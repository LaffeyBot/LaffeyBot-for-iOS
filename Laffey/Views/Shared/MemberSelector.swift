//
//  MemberSelector.swift
//  Laffey
//
//  Created by 戴元平 on 8/18/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

struct MemberSelector: View {
    @State var memberList: [User] = [User]()
    @Binding var selectedMemeber: User
    @Binding var doShowMemberSelector: Bool
    var body: some View {
        NavigationView {
            List {
                ForEach(memberList, id: \.id) { member in
                    Button(action: {
                        self.selectedMemeber = member
                        self.doShowMemberSelector = false
                    }, label: {
                        self.labelFor(member: member)
                    })
                    .foregroundColor(.black)
                    
                }
            }
            .onAppear() {
                self.getData()
            }
            .navigationBarTitle(Text("选择成员"))
            .navigationBarItems(leading:
                Button(action: {
                    self.doShowMemberSelector = false
                }, label: {
                    Text("取消")
                        .foregroundColor(.salmon)
                })
            )
        }
    }
    
    func labelFor(member: User) -> HStack<TupleView<(Text, Spacer, _ConditionalContent<Text, Text>?)>> {
        HStack {
            Text(member.nickname)
            Spacer()
            if member.role == 2 {
                Text("会长")
            } else if member.role == 1 {
                Text("管理员")
            }
        }
    }
    
    func getData() {
        FetchData().getCurrentMembers { (response) in
            switch response {
            case let .success(data):
                withAnimation {
                    self.memberList = data.filter({ (user) -> Bool in
                        user.id != Preferences().userID  // 你不能把你自己踢了。
                    }).sorted(by: { (a, b) -> Bool in
                        a.nickname < b.nickname
                    })
                }
            case .error(_):
                break
            }
        }
    }
}

struct MemberSelector_Previews: PreviewProvider {
    static var previews: some View {
        MemberSelector(selectedMemeber: .constant(Preferences().myself),
                       doShowMemberSelector: .constant(true))
    }
}
