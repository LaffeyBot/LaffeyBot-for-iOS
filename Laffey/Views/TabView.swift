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
                        Image(selection == 0 ? "TimetableSelected" : "Timetable")
                        Text("主页")
                    }
                }
                .tag(0)
            }
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("设定")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
