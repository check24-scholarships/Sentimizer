//
//  NotEnoughData.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import SwiftUI

struct NotEnoughStatsData: View {
    var withHand = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                Image(systemName: "chart.pie")
            }
            .font(.title)
            Text(withHand ? "There is not enough data to show these statistics. Check back later. \(Image(systemName: "hand.wave"))" : "There is not enough data to show statistics. Check back later or choose a larger time interval.")
                .font(.sentiBold(size: 15))
                .bold()
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .if(withHand) { view in
            view.standardBackground()
        }
    }
}

struct NotEnoughData_Previews: PreviewProvider {
    static var previews: some View {
        NotEnoughStatsData()
    }
}
