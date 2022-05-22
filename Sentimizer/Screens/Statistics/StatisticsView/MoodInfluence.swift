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
                    HStack {
                        Text(data.0[index])
                            .font(.senti(size: 20))
                            .padding(5)
                        Text("\(String(format: "%.0f", abs(data.1[index]) * 100))%")
                            .font(.senti(size: 15))
                            .foregroundColor(data.1[index] > 0 ? .green : .red)
                    }
                    
                    HStack {
                        Spacer().frame(width: data.1[index] > 0 ? 0 : nil)
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: width * abs(data.1[index]), height: 3)
                            .gradientForeground(colors: data.1[index] > 0 ? [.green, .green.adjust(brightness: 0.95)] :
                                                    [.red, .red.adjust(brightness: 0.95)],
                                                .leading, .trailing)
                            .padding(5)
                        Spacer().frame(width: data.1[index] < 0 ? 0 : nil)
                    }
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25).foregroundColor(K.brandColor1).opacity(0.1)
        }
    }
}
