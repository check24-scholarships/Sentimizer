//
//  MoodInfluence.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import SwiftUI

struct MoodInfluence: View {
    let data: ([String], [Double])
    
    @Binding var width: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<data.0.count, id: \.self) { index in
                VStack(alignment: .leading) {
                    ActivityNameWithPercentage(name: data.0[index], percentage: data.1[index])
                    
                    PercentageLine(percentage: data.1[index], totalWidth: width)
                }
            }
        }
        .padding()
        .standardBackground()
    }
}

struct ActivityNameWithPercentage: View {
    let name: String
    let percentage: Double
    
    var body: some View {
        HStack {
            Text(name)
                .font(.senti(size: 20))
                .padding(5)
            Text("\(String(format: "%.0f", abs(percentage) * 100))%")
                .font(.senti(size: 15))
                .foregroundColor(percentage > 0 ? .green : .red)
        }
    }
}

struct PercentageLine: View {
    let percentage: Double
    let totalWidth: CGFloat
    
    var body: some View {
        HStack {
            Spacer().frame(width: percentage > 0 ? 0 : nil)
            RoundedRectangle(cornerRadius: 50)
                .frame(width: totalWidth * abs(percentage), height: 3)
                .gradientForeground(colors: percentage > 0 ? [.green, .green.adjust(brightness: 0.95)] :
                                        [.red, .red.adjust(brightness: 0.95)],
                                    .leading, .trailing)
                .padding(5)
            Spacer().frame(width: percentage < 0 ? 0 : nil)
        }
    }
}
