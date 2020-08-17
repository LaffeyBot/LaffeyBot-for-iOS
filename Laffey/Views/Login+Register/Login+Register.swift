//
//  LoginAndRegister.swift
//  Laffey
//  Created by DDavid on 8/15/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

struct LoginAndRegister: View {
    @State var isRegistration = true
    @State var regForm = RegistrationForm()
    @State var didSendOTP = false
    @State var didSendOTPOnce = false
    @State var doShowError = false
    @State var errorMessage = ""
    @EnvironmentObject var shared: Shared
    
    static let OTP_REQUEST_INTERVAL = 20
    @State private var timeRemaining = LoginAndRegister.OTP_REQUEST_INTERVAL
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text(isRegistration ? "注册" : "登录")
                .bold()
                .font(.title)
                .transition(.slide)
            .padding()
            .animation(.none)
            
            Button(action: {
                withAnimation {
                    self.isRegistration.toggle()
                }
            }) {
                Text(isRegistration ?
                    "已有账号？请登录" : "还没有账号？请注册")
                    .transition(.opacity)
                    .foregroundColor(Color.salmon)
            }
            .padding()
            
            TextField(isRegistration ? "用户名" : "用户名/邮箱/手机号",
                      text: $regForm.username)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.horizontal, 30)
            Divider()
                .padding([.leading, .bottom, .trailing], 30)
            
            SecureField("密码", text: $regForm.password)
                .padding(.horizontal, 30)
            Divider()
                .padding([.leading, .bottom, .trailing], 30)
            
            if isRegistration {
                TextField("邮箱", text: $regForm.email)
                    .padding(.horizontal, 30)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                Divider()
                    .padding([.leading, .trailing], 30)
                
                Button(action: {
                    self.sendOTP(to: self.regForm.email)
                }) {
                    Text(didSendOTP ? (String(describing: timeRemaining) + "秒后可重新发送") : "发送验证码")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                }
                .font(.headline)
                .background(didSendOTP ? Color.gray : Color.salmon)
                .foregroundColor(.white)
                .disabled(didSendOTP)
                .cornerRadius(40)
                .padding(30)
                
                if didSendOTPOnce {
                    TextField("邮箱验证码", text: $regForm.otp)
                        .padding(.horizontal, 30)
                        .transition(.opacity)
                        .keyboardType(.numberPad)
                    Divider()
                        .padding([.leading, .trailing], 30)
                        .transition(.opacity)
                }
            }
            
            if doShowError {
                Text(self.errorMessage)
                    .foregroundColor(Color.red)
            }
            
            if !isRegistration || didSendOTPOnce {
                // 如果不是注册，或者是注册且已发送OTP
                Button(action: {
                    self.isRegistration ? self.doRegister() : self.doLogin()
                }) {
                    Text(isRegistration ? "注册" : "登录")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                }
                .font(.headline)
                .background(Color.salmon)
                .foregroundColor(.white)
                .cornerRadius(40)
                .padding(30)
            }
        }
        .keyboardResponsive()
        .onReceive(timer) { time in
            if self.timeRemaining > 0 && self.didSendOTP {
                self.timeRemaining -= 1
            } else {
                self.didSendOTP = false
                self.timeRemaining = LoginAndRegister.OTP_REQUEST_INTERVAL
            }
        }
        
    }
    
    func doLogin() {
        provider.request(.login(loginForm: regForm)) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                guard statusCode != 417 else {
                    self.displayAlert(message: "找不到这个用户喵...")
                    return
                }
                
                guard statusCode != 403 else {
                    self.displayAlert(message: "用户名或密码错误了喵...")
                    return
                }
                
                let decoder = JSONDecoder()
                if let json = try? decoder.decode(LoginResponse.self, from: moyaResponse.data) {
                    // 登录成功
                    var pref = Preferences()
                    pref.authToken = json.jwt
                    pref.username = self.regForm.username
                    pref.password = self.regForm.password
                    pref.userID = json.id
                    pref.didLogin = true
                    self.shared.didlogin = true
                }
            case let .failure(error):
                self.displayAlert(message: "错误：" + error.localizedDescription)
            }
        }
    }
    
    func doRegister() {
        provider.request(.register(regForm: regForm)) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                
                guard statusCode != 422 else {
                    self.displayAlert(message: "用户名必须为三字以上，密码必须为八字以上喵...")
                    return
                }
                
                guard statusCode != 409 else {
                    self.displayAlert(message: "用户名已存在喵...")
                    return
                }
                
                guard statusCode != 410 else {
                    self.displayAlert(message: "邮箱已存在喵...")
                    return
                }
                
                guard statusCode != 403 else {
                    self.displayAlert(message: "邮箱验证码错误了喵...")
                    return
                }
                
                
                if let json = try? JSONDecoder().decode(RegisterResponse.self, from: moyaResponse.data) {
                    var pref = Preferences()
                    pref.authToken = json.jwt
                    pref.username = self.regForm.username
                    pref.password = self.regForm.password
                    pref.userID = json.id
                    pref.didLogin = true
                    self.shared.didlogin = true
                }
                // do something with the response data or statusCode
            case let .failure(error):
                self.displayAlert(message: "错误：" + error.localizedDescription)
            }
        }
    }
    
    func displayAlert(message: String) {
        DispatchQueue.main.async {
            withAnimation {
                self.errorMessage = message
                self.doShowError = true
            }
        }
    }
    
    func sendOTP(to: String) {
        if !to.contains("@") || !to.contains(".") {
            self.displayAlert(message: "Email 格式不正确喵...")
            return
        }
        
        provider.request(.requestOTP(email: to, for: "sign-up")) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                
                guard statusCode != 406 else {
                    self.displayAlert(message: "Email 格式不正确喵...")
                    return
                }
                
                DispatchQueue.main.async {
                    withAnimation {
                        self.didSendOTP = true
                        self.didSendOTPOnce = true
                    }
                }
            case let .failure(error):
                self.displayAlert(message: "错误：" + error.localizedDescription)
                return
            }
        }
    }
}

struct LoginAndRegister_Previews: PreviewProvider {
    static var previews: some View {
        LoginAndRegister().environmentObject(Shared())
    }
}
