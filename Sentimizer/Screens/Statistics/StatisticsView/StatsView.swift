//
//  StatsView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 27.04.22.
//

import SwiftUI
import CoreData

struct StatsView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject private var dataController = DataController()
    
    @State private var timeInterval = K.timeIntervals[0]
    
    @State private var width: CGFloat = 0
    
    @State private var xAxis:[String] = []
    @State private var values:([Double], [Double]) = ([], [])
    @State private var counts:[Int] = []
    
    private var totalCount: Int {
        var count = 0
        for c in counts {
            count += c
        }
        return count
    }
    
    @FetchRequest var entries: FetchedResults<Entry>
    @FetchRequest(entity: Activity.entity(), sortDescriptors: []) var activities: FetchedResults<Activity>
    
    @State var improved = (["Walking", "Training", "Lunch"], [0.75, 0.6, 0.15])
    @State var worsened = (["Project Work", "Gaming"], [-0.4, -0.1])
    
    var body: some View {
        GeometryReader { g in
            ScrollView {
                VStack(alignment: .leading) {
                    Picker("Time Interval", selection: $timeInterval) {
                        ForEach(K.timeIntervals, id: \.self) { interval in
                            Text(interval)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .foregroundColor(.brandColor2)
                    .padding(.vertical, 5)
                    .onChange(of: timeInterval) { newValue in
                        DispatchQueue.global(qos: .userInitiated).async {
                            (xAxis, values) = StatisticsData.getStats(entries: entries, interval: newValue)
                            counts = StatisticsData.getCount(interval: newValue, viewContext: viewContext)
                            (improved, worsened) = StatisticsData.getInfluence(viewContext: viewContext, interval: newValue, activities: activities)
                        }
                    }
                    
                    if totalCount < 1 {
                        VStack {
                            HStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                Image(systemName: "chart.pie")
                            }
                            .font(.title)
                            Text("There is not enough data to show statistics. Check back later or choose a larger time interval.")
                                .font(.senti(size: 15))
                                .bold()
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)
                    } else {
                        
                        Text("Mood")
                            .font(.senti(size: 20))
                            .padding([.leading, .top])
                        
                        MoodTrendChart(xAxis: xAxis, values: values)
                            .frame(height: 200)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.brandColor1).opacity(0.1))
                        
                        Text("Improved Your Mood")
                            .font(.senti(size: 20))
                            .padding([.leading, .top])
                        
                        if improved.0.count == 0 {
                                NotEnoughData()
                        } else {
                            MoodInfluence(data: improved, width: $width)
                                .overlay {
                                    GeometryReader { g in
                                        Color.clear
                                            .onAppear() {
                                                width = g.size.width
                                            }
                                    }
                                }
                        }
                        
                        Text("Worsened Your Mood")
                            .font(.senti(size: 20))
                            .padding([.leading, .top])
                        
                        if worsened.0.count == 0 {
                            NotEnoughData()
                        } else {
                            MoodInfluence(data: worsened, width: $width)
                        }
                        
                        Text("Mood Ratio")
                            .font(.senti(size: 20))
                            .padding([.leading, .top])
                        
                        MoodCount(data: counts, g: g)
                            .frame(maxWidth: .infinity)
                        
                        
                            .padding(.bottom, 20)
                    }
                }
                .padding(.horizontal, 15)
            }
            .onAppear {
                DispatchQueue.global(qos: .userInitiated).async {
                    (xAxis, values) = StatisticsData.getStats(entries: entries, interval: timeInterval)
                    counts = StatisticsData.getCount(interval: timeInterval, viewContext: viewContext)
                    (improved, worsened) = StatisticsData.getInfluence(viewContext: viewContext, interval: timeInterval, activities: activities)
                }
            }
        }
    }
    
    init() {
        let f:NSFetchRequest<Entry> = Entry.fetchRequest()
        // f.fetchLimit = 200
        f.sortDescriptors = [NSSortDescriptor(key: #keyPath(Entry.date), ascending: false)]
        _entries = FetchRequest(fetchRequest: f)
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.brandColor2)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().backgroundColor = UIColor(.brandColor1)
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
