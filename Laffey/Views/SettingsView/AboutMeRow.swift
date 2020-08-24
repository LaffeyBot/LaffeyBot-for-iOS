//
//  AboutMeRow.swift
//  Laffey
//
//  Created by 戴元平 on 8/18/20.
//  Copyright © 2020 Wei Dai. All rights reserved.
//

import SwiftUI

struct AboutMeRow: View {
    @State var key: String = "Key"
    @State var value: String = "Value"
    var body: some View {
        Text(key + ": " + value)
    }
}

struct AboutMeRow_Previews: PreviewProvider {
    static var previews: some View {
        AboutMeRow()
    }
}
