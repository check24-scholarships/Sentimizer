//
//  ContentView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, 2022.
//

import SwiftUI
import CoreData

struct MainActivityView: View {
    //    @EnvironmentObject private var model: Model
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject private var persistenceController = PersistenceController()
    
    @State private var welcomeScreenPresented = false
    @State private var addActivitySheetPresented = false
    
    @State private var selectedMonth = Date()
    
    @State private var entryDays: [String] = []
    @State private var entryContent: [[[String]]] = [[]]
    
    @State private var showLastMonth = false
    
    @FetchRequest var entries: FetchedResults<Entry>
    
    var body: some View {
            ScrollView {
                MonthSwitcher(selectedMonth: $selectedMonth, allowFuture: false)
                    .padding(.bottom)
                
                Group {
                    VStack(alignment: .leading) {
                        SentiButton(icon: "plus.circle", title: "Add Activity")
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .onTapGesture {
                                addActivitySheetPresented = true
                            }
                    }
                    .padding(.horizontal, 5)
                    .padding(.bottom)
                    
                    if entries.count < 1 {
                        VStack {
                            HStack {
                                Image(systemName: "figure.walk")
                                Image(systemName: "fork.knife")
                                Image(systemName: "briefcase.fill")
                            }
                            .font(.title)
                            Text("Create Your First Activity Above")
                                .font(.senti(size: 15))
                                .bold()
                                .padding()
                        }
                        .padding(.top, 50)
                    } else {
                        WhatNext(activity: "Walking")
                            .padding(.bottom, 15)
                            .padding(.horizontal, 5)
                        
                        if persistenceController.getEntryData(entries: entries, month: selectedMonth).0.count < 1  {
                            Text(" \(Image(systemName: "list.bullet.below.rectangle")) There are no entries in the chosen month.")
                                .font(.senti(size: 15))
                                .bold()
                                .padding()
                            
                            let lastMonth = Date.appendMonths(to: selectedMonth, count: -1)
                            if persistenceController.getEntryData(entries: entries, month: lastMonth).0.count > 0 {
                                Text(Calendar.current.monthSymbols[Calendar.current.component(.month, from: selectedMonth)-2] + " \(Calendar.current.component(.year, from: selectedMonth))")
                                    .font(.senti(size: 20))
                                    .minimumScaleFactor(0.8)
                                    .padding()
                                    .onAppear {
                                        showLastMonth = true
                                    }
                            }
                        }
                        
                        ForEach(0..<entryDays.count, id: \.self) { day in
                            VStack(alignment: .leading) {
                                Text(entryDays[day])
                                    .font(.senti(size: 25))
                                    .padding()
                                
                                ForEach(0 ..< entryContent[day].count, id: \.self) { i in
                                    let c = entryContent[day][i]
                                    let c0: String = c[0];
                                    let c1: String = c[1];
                                    let c2: String = c[2];
                                    let c3: String = c[3];
                                    let c4: String = c[4];
                                    let c5: String = c[5];
                                    
                                    NavigationLink { ActivityDetailView(activity: c0, icon: persistenceController.getActivityIcon(activityName: c0, viewContext), description: c3, day: entryDays[day], time: c1, duration: c2, sentiment: c4, id: c5) } label: {
                                        ActivityBar(activity: c0, description: c3, time: (c1, c2), sentiment: c4, id: c5, icon: persistenceController.getActivityIcon(activityName: c0, viewContext))
                                            .padding([.bottom, .trailing], 10)
                                    }
                                }
                            }
                            .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.dayViewBgColor).shadow(color: .gray.opacity(0.3), radius: 5))
                            .padding(.vertical, 5)
                            .padding(.bottom)
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
            .sheet(isPresented: $addActivitySheetPresented) {
                AddActivityView()
                    .environment(\.managedObjectContext, self.viewContext)
            }
            .onAppear() {
                (entryDays, entryContent) = persistenceController.getEntryData(entries: entries)
                welcomeScreenPresented = !UserDefaults.standard.bool(forKey: K.welcomeScreenShown)
            }
            .onChange(of: addActivitySheetPresented) { _ in
                (entryDays, entryContent) = persistenceController.getEntryData(entries: entries)
            }
            .onChange(of: selectedMonth) { newValue in
                showLastMonth = false
                (entryDays, entryContent) = persistenceController.getEntryData(entries: entries, month: newValue)
            }
            .onChange(of: showLastMonth) { newValue in
                if newValue {
                    var dateComponent = DateComponents()
                    dateComponent.month = -1
                    (entryDays, entryContent) = persistenceController.getEntryData(entries: entries, month: Calendar.current.date(byAdding: dateComponent, to: selectedMonth)!)
                }
            }
            .fullScreenCover(isPresented: $welcomeScreenPresented) {
                WelcomeView()
            }
    }
    
    init() {
        let f:NSFetchRequest<Entry> = Entry.fetchRequest()
        f.fetchLimit = 100
        f.sortDescriptors = [NSSortDescriptor(key: #keyPath(Entry.date), ascending: false)]
        _entries = FetchRequest(fetchRequest: f)
    }
}

struct MainActivityView_Previews: PreviewProvider {
    static var previews: some View {
        MainActivityView()
    }
}
