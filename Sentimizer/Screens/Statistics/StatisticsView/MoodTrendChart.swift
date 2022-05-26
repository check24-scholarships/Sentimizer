//
//  MoodTrendChart.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import SwiftUI

struct MoodTrendChart: View {
    let xAxis: [String]
    let values: ([Double], [Double])
    
    var body: some View {
        GeometryReader { g in
            let height = g.size.height
            let width = g.size.width
            
            ZStack(alignment: .leading) {
                ZStack {
                    GeometryReader { g2 in
                        ZStack(alignment: .bottom) {
                            Graph(values: values)
                                .shadow(radius: 10)
                                .padding(.vertical)
                            
                            // Dates
                            ForEach(0..<xAxis.count, id: \.self) { i in
                                let iFloat: CGFloat = CGFloat(i)
                                let countFloat: CGFloat = CGFloat(xAxis.count-1)
                                let x = g2.size.width * (iFloat/countFloat)
                                Text("\(String(describing: xAxis[i]))")
                                    .position(x: x, y: g2.size.height)
                            }
                        }
                    }
                    .padding(.leading, 30)
                    .padding(.horizontal)
                    
                    // Middle lines
                    Path { path in
                        path.move(to: CGPoint(x: 40, y: height - (height/5) + 8))
                        path.addLine(to: CGPoint(x: width, y: height - (height/5) + 8))
                        path.move(to: CGPoint(x: 40, y: height - (height/2)))
                        path.addLine(to: CGPoint(x: width, y: height - (height/2)))
                        path.move(to: CGPoint(x: 40, y: height/5 - 8))
                        path.addLine(to: CGPoint(x: width, y: height/5 - 8))
                    }
                    .stroke(LinearGradient(colors: [.brandColor2.opacity(0.5), .brandColor3.opacity(0.5).adjust(brightness: -0.05)], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
                }
                
                // Senti images
                VStack {
                    ForEach(K.sentimentsArray, id: \.self) { sent in
                        if sent != K.sentimentsArray[1] && sent != K.sentimentsArray[3] {
                            Image(sent)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25)
                                .rotationEffect(.degrees(180))
                                .changeColor(to: .brandColor2)
                        } else {
                            Spacer()
                                .frame(height: 42)
                        }
                    }
                }
                .rotationEffect(.degrees(180))
            }
        }
    }
    
    struct Graph: View {
        let values: ([Double], [Double])
        
        var body: some View {
            GeometryReader { g in
                let height = g.size.height
                let width = g.size.width
                
                Path { path in
                    if values.0.count > 0 {
                        let x = width * values.0[0]
                        let y = height * (1-values.1[0])
                        path.move(to: CGPoint(x: x-3, y: y))
                        path.addArc(center: CGPoint(x: x, y: y), radius: 4, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
                        
                        for i in 1..<values.0.count {
                            let x = width * values.0[i]
                            let y = height * (1-values.1[i])
                            path.addLine(to: CGPoint(x: x, y: y))
                            path.addArc(center: CGPoint(x: x, y: y), radius: 4, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
                        }
                    }
                }
                .stroke(LinearGradient(colors: [.brandColor2, .brandColor3.adjust(brightness: -0.05)], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 4, lineJoin: .round))
            }
            .padding(.vertical)
        }
    }
}
