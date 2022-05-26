//
//  MoodCount.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import SwiftUI

struct MoodCount: View {
    let data: [Int]
    let g: GeometryProxy
    
    var count: Int {
        var count = 0
        for number in data {
            count += number
        }
        return count
    }
    
    
    var sizes: [(Double, Double)] {
        var sizes: [(Double, Double)] = []
        var currentOffset = 0.0
        for index in 0..<data.count {
            let size = Double(data[index])/Double(count) * 0.5
            sizes.append((currentOffset, size + currentOffset))
            currentOffset += size
        }
        return sizes
    }
    
    @State private var circleWidth: CGFloat = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<data.count, id: \.self) { index in
                Circle()
                    .trim(from: sizes[index].0, to: sizes[index].1)
                    .stroke(style: StrokeStyle(lineWidth: 40))
                    .frame(width: g.size.width - g.size.width/3, height: g.size.width - g.size.width/3)
                    .foregroundColor(K.sentimentColors[index < 5 ? index : 0])
                    .rotationEffect(Angle(degrees: 180))
                    .overlay(
                        GeometryReader { g in
                            Color.clear
                                .onAppear {
                                    circleWidth = g.size.width
                                }
                        }
                    )
            }
            HStack {
                ForEach(0..<K.sentimentsArray.count, id: \.self) { index in
                    Image(K.sentimentsArray[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: circleWidth/10)
                        .changeColor(to: K.sentimentColors[index])
                }
            }
            .offset(y: -10)
        }
        .shadow(radius: 10)
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.brandColor1)
                .opacity(0.1)
                .onAppear {
                    circleWidth += 1
                    circleWidth -= 1
                }
                .frame(width: circleWidth + 70, height: circleWidth/2 + 70)
                .offset(y: -(circleWidth + 20)/4)
        }
        .offset(y: 30)
    }
}

