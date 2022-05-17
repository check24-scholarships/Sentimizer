//
//  ContentView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, 2022.
//

import SwiftUI
import CoreData

struct MainActivityView: View {
    @EnvironmentObject private var model: Model
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject private var dataController = DataController()
    
    @State private var addActivitySheetOpened = false
    
    @State private var entryDays: [String] = []
    @State private var entryContent: [[[String]]] = [[]]
    
    @FetchRequest var entries: FetchedResults<Entry>
    
    var body: some View {
        ScrollView {
            Group {
                VStack(alignment: .leading) {
                    SentiButton(icon: "plus.circle", title: "Add Activity")
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .onTapGesture {
                            addActivitySheetOpened = true
                        }
                        .padding(.vertical, 25)
                }
                .padding(.horizontal, 5)
                
                if entryDays.count < 1 {
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
                    
                    ForEach(0..<entryDays.count, id: \.self) { day in
                        VStack(alignment: .leading) {
                            Text(entryDays[day])
                                .font(.senti(size: 25))
                                .padding()
                            
                            ForEach(0 ..< entryContent[day].count, id: \.self) { i in
                                let c = entryContent[day][i]
                                let icon = dataController.getActivityIcon(viewContext: viewContext, name: c[0])
                                NavigationLink { ActivityDetailView(activity: c[0], icon: icon, description: c[3], day: entryDays[day], time: c[1], duration: c[2], sentiment: c[4], id: c[5]) } label: {
                                    ActivityView(activity: c[0], description: c[3], time: (c[1], c[2]), sentiment: c[4], id: c[5], icon:icon)
                                        .padding([.bottom, .trailing], 10)
                                }
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 25).foregroundColor(K.dayViewBgColor).shadow(color: .gray.opacity(0.7), radius: 10))
                        .padding(.vertical, 5)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 30)
        }
        .sheet(isPresented: $addActivitySheetOpened) {
            AddActivityView()
                .environment(\.managedObjectContext, self.viewContext)
        }
        .onAppear() {
            (entryDays, entryContent) = dataController.getEntryData(entries: entries)
            // DataController.deleteAllData(moc: viewContext)
        }
        .onChange(of: addActivitySheetOpened) { _ in
            (entryDays, entryContent) = dataController.getEntryData(entries: entries)
        }
    }
    
    init() {
        let f:NSFetchRequest<Entry> = Entry.fetchRequest()
        f.fetchLimit = 100
        f.sortDescriptors = [NSSortDescriptor(key: #keyPath(Entry.date), ascending: false)]
        _entries = FetchRequest(fetchRequest: f)
    }
}

//MARK: - Activity Bar
struct ActivityView: View {
    
    let activity: String
    let description: String?
    let time: (String, String)
    let sentiment: String
    let id: String
    let icon: String
    
    var body: some View {
        HStack {
            Text(time.0)
                .font(.senti(size: 20))
                .padding([.leading, .top, .bottom])
                .padding(.trailing, 3)
            
            HStack {
                Image(systemName: icon)
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(activity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .padding(.top, 5)
                        .padding(2)
                    
                    let isEmpty = (description ?? "").isEmpty
                    let description = (description ?? "").isEmpty ? "Describe your activity..." : description ?? "Describe your activity..."
                    Text(description)
                        .font(.senti(size: 18))
                        .opacity(isEmpty ? 0.5 : 1.0)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 10)
                        .padding(.leading, 2)
                }
                Spacer()
                Image(sentiment)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                    .padding(15)
                    .changeColor(to: .white)
                    .background(Rectangle().gradientForeground(.leading, .trailing).frame(height: 100))
            }
            .font(.senti(size: 25))
            .foregroundColor(.white)
            .background(
                Rectangle()
                    .gradientForeground())
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }
}

struct MainActivityView_Previews: PreviewProvider {
    static var previews: some View {
        MainActivityView()
            .environmentObject(Model())
    }
}
