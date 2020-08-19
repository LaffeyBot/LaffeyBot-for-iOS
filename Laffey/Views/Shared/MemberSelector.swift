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
        List {
            ForEach(memberList, id: \.id) { member in
                Button(action: {
                    selectedMemeber = member
                    doShowMemberSelector = false
                }, label: {
                    Text(member.nickname)
                })
                .foregroundColor(.black)
                
            }
        }
        .onAppear() {
            getData()
        }
    }
    
    func getData() {
        FetchData().getCurrentMembers { (response) in
            switch response {
            case let .success(data):
                self.memberList = data
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
