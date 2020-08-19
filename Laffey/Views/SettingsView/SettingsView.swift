//
//  SettingsView.swift
//  Laffey
//
//  Created by 戴元平 on 8/18/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var email: String = Preferences().username
    var body: some View {
        NavigationView {
                List {
                    Section(header: Text("关于我")) {
                        AboutMeRow()
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle(Text("设定"))
        }
    }
}

@available(iOS 14.0, *)
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
