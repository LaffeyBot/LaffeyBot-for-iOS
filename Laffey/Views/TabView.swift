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
                    VStack {
                        Text("Laffey")
                            .font(.title)
                        Text("Laffey 2")
                            .font(.callout)
                    }
                    Text("Laffey 3 ")
                }
                
                    .tabItem {
                        VStack {
                            Image("first")
                            Text("First")
                        }
                    }
                .tag(0)
            }
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Second")
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
