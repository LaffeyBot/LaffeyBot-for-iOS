//
//  PNPromptView.swift
//  Laffey
//
//  Created by 戴元平 on 8/17/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

struct PNPromptView: View {
    @Binding var doPresentPNPrompt: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("打开推送通知")
                .bold()
                .font(.system(size: 40))
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("打开推送通知之后，指挥官就可以：")
                Text("- 及时获取出刀信息")
                Text("- 随时了解Boss血量")
                Text("- 获取国服活动提醒")
                Text("推送不包含任何广告，请放心开启喵！")
            }
            
            Spacer()
            
            Button(action: {
                let appDelegate = UIApplication.shared.delegate as! XGPushDelegate
                XGPush.defaultManager().startXG(withAccessID: 1600012020, accessKey: "I8H2ON40VAM2", delegate: appDelegate)
                self.doPresentPNPrompt = false
            }) {
                Text("开启推送")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
            }
            .font(.headline)
            .background(Color.salmon)
            .foregroundColor(.white)
            .cornerRadius(40)
            .padding(30)
            
            Button(action: {
                self.doPresentPNPrompt = false
            }) {
                Text("不开启")
                    .transition(.opacity)
                    .foregroundColor(Color.salmon)
            }
            
            Spacer()
        }
        .onAppear() {
            Preferences().didPromptPN = true
        }
    }
}

struct PNPromptView_Previews: PreviewProvider {
    static var previews: some View {
        PNPromptView(doPresentPNPrompt: .constant(true))
    }
}
