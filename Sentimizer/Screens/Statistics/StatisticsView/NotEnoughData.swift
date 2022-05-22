//
//  NotEnoughData.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import SwiftUI

struct NotEnoughData: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                Image(systemName: "chart.pie")
            }
            .font(.title)
            Text("There is not enough data to show these statistics. Check back later. \(Image(systemName: "hand.wave"))")
                .font(.senti(size: 15))
                .bold()
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .standardBackground()
    }
}

struct NotEnoughData_Previews: PreviewProvider {
    static var previews: some View {
        NotEnoughData()
    }
}
