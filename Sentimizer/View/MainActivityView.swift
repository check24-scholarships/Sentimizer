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
                    ViewTitle("Activities")
                    
                    SentiButton(icon: "plus.circle", title: "Add Activity")
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .onTapGesture {
                            addActivitySheetOpened = true
                        }
                        .padding(.vertical, 25)
                }
                
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
                    
                    ForEach(0..<entryDays.count, id: \.self) { day in
                        VStack(alignment: .leading) {
                            Text(entryDays[day])
                                .font(.senti(size: 25))
                                .padding()
                            
                            ForEach(0 ..< entryContent[day].count, id: \.self) { i in
                                let c = entryContent[day][i]
                                Activity(activity: c[0], description: c[3], time: c[1], duration: c[2], sentiment: c[4])
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 15)
        }
        .sheet(isPresented: $addActivitySheetOpened) {
            AddActivityView()
                .environment(\.managedObjectContext, self.viewContext)
        }
        .onAppear() {
            (entryDays, entryContent) = DataController.getEntryData(entries: entries)
        }
        .onChange(of: addActivitySheetOpened) { _ in
            (entryDays, entryContent) = DataController.getEntryData(entries: entries)
        }
    }
    
    init() {
        let f:NSFetchRequest<Entry> = Entry.fetchRequest()
        f.fetchLimit = 20
        f.sortDescriptors = [NSSortDescriptor(key: #keyPath(Entry.date), ascending: true)]
        _entries = FetchRequest(fetchRequest: f)
    }
}

//MARK: - Activity Bar
struct Activity: View {
    
    let activity: String
    let description: String?
    let time: String
    let duration: String
    let sentiment: String
    
    @State var width: CGFloat = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(time)
                Text(duration + "min")
            }
            .font(.senti(size: 20))
            .padding([.leading, .top, .bottom])
            .padding(.trailing, 3)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(activity)
                    .padding(.top, 5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .overlay {
                        GeometryReader { g in
                            Color.clear
                                .onAppear {
                                    width = g.frame(in: .local).width
                                }
                                .onChange(of: g.frame(in: .local).width) { newValue in
                                    width = newValue
                                }
                        }
                    }
                if let description = description, !description.isEmpty {
                    Text(description)
                        .font(.senti(size: 18))
                        .opacity(0.7)
                        .lineLimit(2)
                        .padding(.bottom, 10)
                }
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

struct MainActivityView_Previews: PreviewProvider {
    static var previews: some View {
        MainActivityView()
            .environmentObject(Model())
    }
}

struct WhatNext: View {
    let activity: String
    
    var body: some View {
        VStack {
            Text("What should I do next?")
                .font(.senti(size: 20))
                .gradientForeground()
            Text("Sentimizer recommends this activity:")
                .font(.senti(size: 15))
                .opacity(0.7)
            SentiButton(icon: "figure.walk", title: activity, chevron: false)
                .scaleEffect(0.8)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25).foregroundColor(K.brandColor1).opacity(0.1))
    }
}
