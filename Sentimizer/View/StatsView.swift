//
//  StatsView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 27.04.22.
//

import SwiftUI

struct StatsView: View {
    
    @State var timeInterval = K.timeIntervals[0]
    
    @State var width: CGFloat = 0
    
    let testData = ([0.0, 0.0, 0.5, 0.25, 0.75, 1.0], ["8:15", "8:31", "9:44", "12:57", "14:19", "15:35"])
    let testData2 = (["Walking", "Training", "Lunch"], [0.75, 0.6, 0.15])
    let testData3 = (["Project Work", "Gaming"], [-0.4, -0.1])
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ViewTitle("Statistics")
                
                Picker("Time Interval", selection: $timeInterval) {
                    ForEach(K.timeIntervals, id: \.self) { interval in
                        Text(interval)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .foregroundColor(K.brandColor2)
                .padding(.vertical, 5)
                .onAppear {
                    UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(K.brandColor2)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
                    UISegmentedControl.appearance().backgroundColor = UIColor(K.brandColor1)
                }
                
                Text("Mood")
                    .font(.senti(size: 20))
                    .padding([.leading, .top])
                
                MoodTrendChart(dataPoints: testData)
                    .frame(height: 200)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 25).foregroundColor(K.brandColor1).opacity(0.1))
                
                Text("Improved Your Mood")
                    .font(.senti(size: 20))
                    .padding([.leading, .top])
                
                
                MoodInfluence(data: testData2, width: $width)
                    .overlay {
                        GeometryReader { g in
                            Color.clear
                                .onAppear() {
                                    width = g.size.width
                                }
                        }
                    }
                
                Text("Worsened Your Mood")
                    .font(.senti(size: 20))
                    .padding([.leading, .top])
                
                MoodInfluence(data: testData3, width: $width)
                
                
                    .padding(.bottom, 30)
            }
            .padding(.horizontal, 15)
        }
    }
}

//MARK: MoodTrendChart
struct MoodTrendChart: View {
    let dataPoints: ([Double], [String])
    
    var body: some View {
        GeometryReader { g in
            let height = g.size.height
            let width = g.size.width
            
            ZStack(alignment: .leading) {
                ZStack {
                    GeometryReader { g2 in
                        ZStack(alignment: .bottom) {
                            Graph(dataPoints: dataPoints.0)
                                .shadow(radius: 10)
                                .padding(.vertical)
                            
                            // Dates
                            ForEach(0..<dataPoints.1.count, id: \.self) { i in
                                let iFloat: CGFloat = CGFloat(i)
                                let countFloat: CGFloat = CGFloat(dataPoints.1.count-1)
                                let x = g2.size.width * (iFloat/countFloat)
                                Text("\(String(describing: dataPoints.1[i]))")
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
                    .stroke(LinearGradient(colors: [K.brandColor2.opacity(0.5), K.brandColor3.opacity(0.5)], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
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
                                .changeColor(to: K.brandColor2)
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
        let dataPoints: [Double]
        
        var body: some View {
            GeometryReader { g in
                let height = g.size.height
                let width = g.size.width
                
                Path { path in
                    let y = height * (1-dataPoints[0])
                    path.move(to: CGPoint(x: -3, y: y))
                    path.addArc(center: CGPoint(x: 0, y: y), radius: 4, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
                    
                    for i in 1..<dataPoints.count {
                        let x = CGFloat((CGFloat(i)/(CGFloat(dataPoints.count)-1))) * width
                        let y = height * (1-dataPoints[i])
                        path.addLine(to: CGPoint(x: x, y: y))
                        path.addArc(center: CGPoint(x: x, y: y), radius: 4, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
                    }
                }
                .stroke(LinearGradient(colors: [K.brandColor2, K.brandColor3], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 4, lineJoin: .round))
            }
            .padding(.vertical)
        }
    }
}

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
                        Text("\(String(format: "%.0f", abs(data.1[index]) * 100))% \(data.1[index] > 0 ? "positive" : "negative")")
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

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .font(.senti(size: 12))
            .minimumScaleFactor(0.8)
            .foregroundColor(.gray)
    }
}
