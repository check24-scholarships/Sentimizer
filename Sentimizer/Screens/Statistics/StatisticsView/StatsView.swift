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
    @EnvironmentObject private var model: Model
    
    @StateObject private var persistenceController = PersistenceController()
    
    @State private var timeInterval = K.timeIntervals[0]
    
    @State private var width: CGFloat = 0
    
    @State private var xAxis: [String] = []
    @State private var values: ([Double], [Double]) = ([], [])
    @State private var counts: [Int] = []
    
    private var totalCount: Int {
        var count = 0
        for c in counts {
            count += c
        }
        return count
    }
    
    @FetchRequest var entries: FetchedResults<Entry>
    @FetchRequest(entity: Activity.entity(), sortDescriptors: []) var activities: FetchedResults<Activity>
    
    @State private var improved: ([String], [Double]) = ([], [])
    @State private var worsened: ([String], [Double]) = ([], [])
    @State private var influenceTimeInterval: String.LocalizationValue = "Last Month"
    
    @State private var addActivitySheetPresented = false
    @State private var activityToAdd = ""
    
    @AppStorage(K.colorTheme) private var colorTheme = false
    
    var body: some View {
        GeometryReader { g in
            ScrollView {
                VStack(alignment: .leading) {
                    Picker("Time Interval", selection: $timeInterval) {
                        ForEach(K.timeIntervals, id: \.self) { interval in
                            Text(LocalizedStringKey(interval))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 5)
                    .onChange(of: timeInterval) { _ in
                        fillChartsData()
                    }
                    
                    if totalCount < 1 {
                        NotEnoughStatsData()
                        .padding(.top, 50)
                    } else {
                        
                        Text("Sentimizer's Recommendation")
                            .font(.sentiBold(size: 20))
                            .padding([.leading, .top])
                        
                        WhatNext(backgroundGray: true, addSheetPresented: $addActivitySheetPresented, activityToAdd: $activityToAdd)
                        
                        Text("Mood")
                            .font(.sentiBold(size: 20))
                            .padding([.leading, .top])
                        
                        MoodTrendChart(xAxis: xAxis, values: values)
                            .frame(height: 200)
                            .padding()
                            .standardBackground()
                        
                        Text("\(String(localized: "Improved Your Mood")) - \(String(localized: influenceTimeInterval))")
                            .font(.sentiBold(size: 20))
                            .minimumScaleFactor(0.7)
                            .padding([.leading, .top])
                        
                        if improved.0.count == 0 {
                                NotEnoughStatsData(withHand: true)
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
                        
                        Text("\(String(localized: "Worsened Your Mood")) - \(String(localized: influenceTimeInterval))")
                            .font(.sentiBold(size: 20))
                            .minimumScaleFactor(0.7)
                            .padding([.leading, .top])
                        
                        if worsened.0.count == 0 {
                            NotEnoughStatsData(withHand: true)
                        } else {
                            MoodInfluence(data: worsened, width: $width)
                        }
                        
                        Text("Mood Ratio")
                            .font(.sentiBold(size: 20))
                            .padding([.leading, .top])
                        
                        MoodCount(data: counts, g: g)
                            .frame(maxWidth: .infinity)
                        
                        
                            .padding(.bottom, 20)
                    }
                }
                .padding(.horizontal, 15)
            }
            .onAppear {
                fillChartsData()
            }
            .onChange(of: colorTheme) { _ in
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.brandColor2)
            }
            .onChange(of: addActivitySheetPresented) { _ in
                fillChartsData()
            }
            .sheet(isPresented: $addActivitySheetPresented) {
                AddActivityView(activity: activityToAdd)
                    .environment(\.managedObjectContext, self.viewContext)
            }
        }
    }
    
    init() {
        let f:NSFetchRequest<Entry> = Entry.fetchRequest()
        f.sortDescriptors = [NSSortDescriptor(key: #keyPath(Entry.date), ascending: false)]
        _entries = FetchRequest(fetchRequest: f)
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.brandColor2)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().backgroundColor = UIColor(.gray)
    }
    
    func fillChartsData() {
        let chart1 = StatisticsData.getStats(entries: entries, interval: timeInterval)
        DispatchQueue.main.async {
            (xAxis, values) = chart1
        }
        
        let chart3 = StatisticsData.getCount(interval: timeInterval, viewContext: viewContext)
        DispatchQueue.main.async {
            counts = chart3
        }
        
        if timeInterval == K.timeIntervals[3] {
            improved = model.influenceImprovedYear
            worsened = model.influenceWorsenedYear
            
            influenceTimeInterval = "Last Year"
        } else {
            improved = model.influenceImprovedMonth
            worsened = model.influenceWorsenedMonth
            
            influenceTimeInterval = "Last Month"
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .font(.sentiBold(size: 12))
            .minimumScaleFactor(0.8)
            .foregroundColor(.gray)
    }
}
