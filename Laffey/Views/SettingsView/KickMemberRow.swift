//
//  KickMemberRow.swift
//  Laffey
//
//  Created by 戴元平 on 8/19/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

struct KickMemberRow: View {
    @State var doShowMemberSelector: Bool = false
    @State var doShowKickMemberAlert: Bool = false
    @State var alert: Alert = Alert(title: Text("Default"))
    @State var memberToBeKicked: User = Preferences().myself
    
    var body: some View {
        Button(action: {
            self.doShowMemberSelector.toggle()
        }, label: {
            Text("踢出成员")
        })
        .foregroundColor(.black)
        .sheet(isPresented: $doShowMemberSelector, onDismiss: {
            if memberToBeKicked != Preferences().myself {
                self.alert = Alert(title: Text("踢出成员"),
                                   message:
                                     Text("你确定要踢出" + memberToBeKicked.nickname + "吗？此操作不可逆。"),
                                   primaryButton: .destructive(Text("确认踢出"), action: {
                                     self.kickMember()
                                   }), secondaryButton: .cancel({
                                     memberToBeKicked = Preferences().myself
                                   }))
                self.doShowKickMemberAlert.toggle()
            }
        }, content: {
            MemberSelector(selectedMemeber: $memberToBeKicked, doShowMemberSelector: $doShowMemberSelector)
        })
        .alert(isPresented: $doShowKickMemberAlert, content: {
            self.alert
        })
    }
    
    func kickMember() {
        provider.request(.kickMember(user: memberToBeKicked)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    self.alert = Alert(title: Text("踢出成功"),
                                       message: Text("已踢出" + memberToBeKicked.nickname + "。"), dismissButton: nil)
                } else if response.statusCode == 403 {
                    self.alert = Alert(title: Text("错误"),
                                       message: Text("不是会长，没有权限踢出成员。"), dismissButton: nil)
                }
                self.alert = Alert(title: Text("错误"),
                                   message: Text("未知错误"), dismissButton: nil)
            case let .failure(error):
                self.alert = Alert(title: Text("错误"),
                                   message: Text(error.localizedDescription), dismissButton: nil)
            }
            self.doShowKickMemberAlert.toggle()
            memberToBeKicked = Preferences().myself
        }
    }
}

struct KickMemberRow_Previews: PreviewProvider {
    static var previews: some View {
        KickMemberRow()
    }
}
