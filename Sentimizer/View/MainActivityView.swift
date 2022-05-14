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
    
    @State var addActivitySheetOpened = false
    
    @State var entryDays: [String] = []
    @State var entryContent: [[[String]]] = [[]]
    
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
                                NavigationLink { ActivityDetailView(activity: c[0], icon: "figure.walk", description: c[3], day: entryDays[day], time: c[1], duration: c[2], sentiment: c[4], id: c[5]) } label: {
                                    Activity(activity: c[0], description: c[3], time: c[1], duration: c[2], sentiment: c[4], id: c[5])
                                        .padding([.bottom, .trailing], 5)
                                }
                            }
                        }
                        .padding(.bottom)
                        .background(RoundedRectangle(cornerRadius: 25).foregroundColor(K.dayViewBgColor).shadow(radius: 10))
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
            (entryDays, entryContent) = DataController.getEntryData(entries: entries)
            // DataController.deleteAllData(moc: viewContext)
        }
        .onChange(of: addActivitySheetOpened) { _ in
            (entryDays, entryContent) = DataController.getEntryData(entries: entries)
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
struct Activity: View {
    @Environment(\.managedObjectContext) var viewContext
    
    let activity: String
    let description: String
    let time: String
    let duration: String
    let sentiment: String
    let id: String
    
    var body: some View {
        HStack {
            VStack {
                Text(time)
                Text(duration + " min")
            }
            .font(.senti(size: 20))
            .padding([.leading, .top, .bottom])
            .padding(.trailing, 3)
            
            HStack {
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "figure.walk")
                            .scaleEffect(0.9)
                            .padding([.leading, .top], 5)
                        Text(activity)
                            .padding(.vertical, 5)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                    .padding(5)
                    
                    Text(description.isEmpty ? "Describe your activity..." : description)
                        .font(.senti(size: 18))
                        .opacity(description.isEmpty ? 0.5 : 1.0)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
                
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
