//
//  LinkQQAccount.swift
//  Laffey
//
//  Created by 戴元平 on 8/22/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

struct LinkQQAccount: View {
    var accountName: String = Preferences().username
    @State var isSubmitting: Bool = false
    @State var doDisplayError: Bool = false
    @State var errorText: String = ""
    @EnvironmentObject var shared: Shared
    var body: some View {
        VStack {
            Text("绑定QQ")
                .bold()
                .font(.system(size: 40))
                .padding()
            Text("绑定后将自动加入QQ所属的公会")
                .font(.body)
                .padding()
            VStack(alignment: HorizontalAlignment.leading, spacing: 30, content: {
                HStack {
                    Text("绑定方法：")
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    Text("向QQ：")
                    Text("3473890852")
                        .foregroundColor(.salmon)
                    
                    Spacer()
                    
                    Button(action: {
                        let pasteboard = UIPasteboard.general
                        pasteboard.string = "3473890852"
                    }) {
                        Text("点击复制")
                            .frame(minWidth: 0, maxWidth: 80, minHeight: 30, maxHeight: 40)
                    }
                    .font(.headline)
                    .background(Color.white)
                    .foregroundColor(Color.salmon)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.salmon, lineWidth: 2)
                    )
                    .padding([[.vertical]], 0)
                }
                
                HStack {
                    Text("发送：")
                    Text("「绑定账户 " + accountName + "」")
                        .foregroundColor(.salmon)
                    
                    Spacer()
                    
                    Button(action: {
                        let pasteboard = UIPasteboard.general
                        pasteboard.string = "绑定账户 " + accountName
                    }) {
                        Text("点击复制")
                            .frame(minWidth: 0, maxWidth: 80, minHeight: 30, maxHeight: 40)
                    }
                    .font(.headline)
                    .background(Color.white)
                    .foregroundColor(Color.salmon)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.salmon, lineWidth: 2)
                    )
                    .padding([[.vertical]], 0)
                }
            })
            .padding()
            
            Spacer()
            
            if doDisplayError {
                Text(self.errorText)
                    .foregroundColor(.red)
            }
            Button(action: {
                self.checkGroup()
            }) {
                if !isSubmitting {
                    Text("我已绑定")
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
            .padding(30)
        }
    }
    
    func checkGroup() {
        self.isSubmitting = true
        self.doDisplayError = false
        provider.request(
            .login(loginForm:
                    RegistrationForm(username: Preferences().username,
                                     password: Preferences().password,
                                     email: "",
                                     otp: "")
            )) { result in
            self.isSubmitting = false
            switch result {
            case let .success(response):
                let decoder = JSONDecoder()
                if let json = try? decoder.decode(LoginResponse.self, from: response.data) {
                    self.processResponse(user: json.user)
                }
            case let .failure(error):
                self.displayError(msg: error.localizedDescription)
            }
        }
    }
    
    func displayError(msg: String) {
        withAnimation {
            self.doDisplayError = true
            self.errorText = msg
        }
    }
    
    func processResponse(user: User) {
        if user.qq == nil || user.group_id == nil {
            displayError(msg: "好像还不能找到绑定的账号...再试一下吧。")
        } else {
            Preferences().qq = user.qq!
            Preferences().groupID = user.group_id!
            Preferences().didJoinGroup = true
            shared.didJoinGroup = true
        }
    }
}

struct LinkQQAccount_Previews: PreviewProvider {
    static var previews: some View {
        LinkQQAccount()
    }
}
