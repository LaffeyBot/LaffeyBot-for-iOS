//
//  DashboardStatsView.swift
//  Laffey
//
//  Created by 戴元平 on 8/19/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

struct DashboardStatsView: View {
    @ObservedObject var currentRecord: TeamRecordNative
    var body: some View {
        VStack {
            Text("当前攻略")
                .font(.largeTitle)
            
            VStack {
                HStack {
                    Text(String(currentRecord.current_boss_gen))
                    Text("周目")
                }
                HStack {
                    Text(String(currentRecord.current_boss_order))
                        .font(.largeTitle)
                        .foregroundColor(Color.salmon)
                    Text("王")
                        .font(.largeTitle)
                        .foregroundColor(Color.salmon)
                }
            }
            
            Text("剩余血量：" + String(currentRecord.boss_remaining_health))
            ProgressBar(value: $currentRecord.boss_health_percentage)
                .frame(minHeight: 30)
                .padding()
                .transition(.identity)
                .animation(.none)
        }
    }
}

struct DashboardStatsView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardStatsView(currentRecord: RealmDatabase().getCurrentTeamRecord(current: TeamRecordNative()))
    }
}
