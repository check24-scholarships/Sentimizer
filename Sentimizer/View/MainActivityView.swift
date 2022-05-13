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
    
    @State var deleteSwiped = false
    
    
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
                                Activity(activity: c[0], description: c[3], time: c[1], duration: c[2], sentiment: c[4], id: c[5], isSwiped: $deleteSwiped)
                                    .padding([.bottom, .trailing], 5)
                            }
                        }
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
            // deleteAllData(moc: viewContext)
        }
        .onChange(of: addActivitySheetOpened) { _ in
            (entryDays, entryContent) = DataController.getEntryData(entries: entries)
        }
        .onChange(of: deleteSwiped) { _ in
            withAnimation(.easeIn) {
                (entryDays, entryContent) = DataController.getEntryData(entries: entries)
            }
        }
    }
    
    init() {
        let f:NSFetchRequest<Entry> = Entry.fetchRequest()
        f.fetchLimit = 20
        f.sortDescriptors = [NSSortDescriptor(key: #keyPath(Entry.date), ascending: true)]
        _entries = FetchRequest(fetchRequest: f)
    }
}

func deleteAllData(moc: NSManagedObjectContext) {
    let fetchRequest: NSFetchRequest<Entry>
    fetchRequest = Entry.fetchRequest()
    fetchRequest.predicate = NSPredicate(value: true)
    
    let entries = try! moc.fetch(fetchRequest)
    
    for entry in entries {
        moc.delete(entry)
    }
    
    try! moc.save()
}

//MARK: - Activity Bar
struct Activity: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    let activity: String
    let description: String?
    let time: String
    let duration: String
    let sentiment: String
    let id: String
    
    @State var width: CGFloat = 0
    @Binding var isSwiped: Bool
    
    @State var offset: CGFloat = 0
    
    var body: some View {
        HStack {
            VStack {
                Text(time)
                Text(duration + " min")
            }
            .font(.senti(size: 20))
            .padding([.leading, .top, .bottom])
            .padding(.trailing, 3)
            
            ZStack {
                HStack {
                    Spacer()
                    Button {
                        deleteActivity(moc: viewContext)
                    } label: {
                        Image(systemName: "trash")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 90, height: 50)
                    }
                }
                .background(Rectangle().foregroundColor(.red).frame(height: 200))
                
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
                        }
                        .padding(5)
                        if let description = description, !description.isEmpty {
                            Text(description)
                                .font(.senti(size: 18))
                                .opacity(0.7)
                                .lineLimit(2)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)
                        }
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
                .background(
                    Rectangle()
                        .gradientForeground())
                .offset(x: offset)
                .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
            }
            .font(.senti(size: 25))
            .foregroundColor(.white)
            .background(
                Rectangle()
                    .gradientForeground())
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }
    
    func onChanged(value: DragGesture.Value) {
        if value.translation.width < 0 {
            if isSwiped {
                offset = value.translation.width - 90
            } else {
                offset = value.translation.width
            }
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeOut) {
            if value.translation.width < 0 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    offset = -1000
                    deleteActivity(moc: viewContext)
                } else if -offset > 50 {
                    isSwiped = true
                    offset = -90
                } else {
                    isSwiped = false
                    offset = 0
                }
            } else {
                isSwiped = false
                offset = 0
            }
        }
    }
    
    func deleteActivity(moc: NSManagedObjectContext) {
        let objectID = moc.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: URL(string: id)!)!
        
        let object = try! moc.existingObject(with: objectID)
        
        moc.delete(object)
        
        do {
            try moc.save()
        } catch {
            print("In \(#function), line \(#line), save activity failed:")
            print(error.localizedDescription)
        }
        
        isSwiped = false
    }
}

struct MainActivityView_Previews: PreviewProvider {
    static var previews: some View {
        MainActivityView()
            .environmentObject(Model())
//        Activity(activity: "Project Work", description: "HellloHellloHellloHellloHellloHellloHellloHellloHellloHellloHellloHellloHellloHelllo ", time: "08:15", duration: "10", sentiment: "happy", id:"0")
    }
}
