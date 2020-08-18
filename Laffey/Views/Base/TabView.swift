//
//  ContentView.swift
//  Laffey
//
//  Created by DDavid on 8/14/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            Group {
                HStack{
                    Dashboard()
                }
                .tabItem {
                    VStack {
                        Image(selection == 0 ? "TodaySelected" : "Today")
                        Text("主页")
                    }
                }
                .tag(0)
            }
            
            Group {
                HStack{
                    RecordListView()
                }
                .tabItem {
                    VStack {
                        Image(selection == 1 ? "TimetableSelected" : "Timetable")
                        Text("记录")
                    }
                }
                .tag(1)
            }
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("设定")
                    }
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
