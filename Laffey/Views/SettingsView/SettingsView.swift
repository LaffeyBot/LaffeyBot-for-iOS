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
    @State var memberToBeKicked: User = Preferences().myself
    @State var doShowMemberSelector: Bool = false
    var body: some View {
        NavigationView {
                List {
                    Section(header: Text("关于我")) {
                        AboutMeRow()
                    }
                    
                    Section(header: Text("关于公会")) {
                        Button(action: {
                            self.doShowMemberSelector.toggle()
                        }, label: {
                            Text("踢出成员")
                        })
                        .foregroundColor(.black)
                        .sheet(isPresented: $doShowMemberSelector, onDismiss: {
                            if memberToBeKicked != Preferences().myself {
                                self.kickMember()
                            }
                        }, content: {
                            MemberSelector(selectedMemeber: $memberToBeKicked, doShowMemberSelector: $doShowMemberSelector)
                        })
                        
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle(Text("设定"))
        }
    }
    
    func kickMember() {
        
    }
}

@available(iOS 14.0, *)
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
