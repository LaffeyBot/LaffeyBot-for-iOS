//
//  MainView.swift
//  Laffey
//
//  Created by 戴元平 on 8/15/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var shared: Shared
    
    var body: some View {
        VStack {
            if !self.shared.didlogin {
                LoginAndRegister()
            } else {
                Dashboard()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(Shared())
    }
}
