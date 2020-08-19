//
//  LogoutRow.swift
//  Laffey
//
//  Created by 戴元平 on 8/19/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI
import RealmSwift

struct LogoutRow: View {
    @State var doShowAlert: Bool = false
    var body: some View {
        Button(action: {
            self.doShowAlert.toggle()
        }, label: {
            Text("退出登录")
        })
        .alert(isPresented: $doShowAlert, content: {
            Alert(title: Text("确定要退出登录吗？"),
                  message: Text("退出登录之后, 所有记录都会被清除。"),
                  primaryButton: .destructive(
                    Text("确认"), action: {
                        self.doLogout()
                    }), secondaryButton: .cancel())
        })
    }
    
    func doLogout() {
        Preferences().myself = User(id: 0, group_id: nil, role: 0, username: "", nickname: "")
        Preferences().didLogin = false
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        if Preferences().didEnablePN {
            provider.request(.unlinkToken(token: XGPushTokenManager.default().deviceTokenString ?? "")) { _ in
                
            }
        }
    }
}

struct LogoutRow_Previews: PreviewProvider {
    static var previews: some View {
        LogoutRow()
    }
}
