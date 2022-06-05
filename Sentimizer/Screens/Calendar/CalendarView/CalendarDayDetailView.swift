//
//  CalendarDayDetailView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 18.05.22.
//

import SwiftUI

struct CalendarDayDetailView: View {
    let date: Date
    
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject private var persistenceController = PersistenceController()
    
    @State private var content: [ActivityData] = []
    
    @State private var editing = false
    
    var hours: [String] {
        var hours: [String] = []
        for hour in 0...23 {
            hours.append("\(hour):00")
        }
        
        return hours
    }
    
    var day: String {
        return "\(DateFormatter.formatDate(date: date, format: "EE")), \(DateFormatter.formatDate(date: date, format: "d. MMM"))"
    }
    
    var body: some View {
//        NavigationView {
        ZStack(alignment: .topLeading) {
            ScrollView {
                    VStack(spacing: 0) {
                        HStack(alignment: .top) {
                            ViewTitle(day, padding: false)
                                .padding(.top, 10)
                                .frame(maxWidth: .infinity)
                                .padding(.leading)
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    editing.toggle()
                                }
                            } label: {
                                VStack {
                                    if !editing {
                                        Image(systemName: "list.number")
                                            .standardIcon(width: 25)
                                            .frame(height: 25)
                                            .padding(13)
                                            .standardBackground()
                                    }
                                    Text(editing ? "Done" : "Edit order")
                                        .bold()
                                        .padding(editing ? 20 : 0)
                                        .font(.senti(size: editing ? 20 : 12))
                                }
                                .padding(.trailing)
                            }
                        }
                        .padding(.top, 25)
                        
                        if content.count < 1 {
                            Text("There are no entries for this day. Add entries or choose another.")
                                .font(.senti(size: 15))
                                .padding()
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(K.timeSections, id: \.self) { timeSection in
                                
                                if getDataForSection(content: content, timeSection).count > 0 {
                                    getTitleForSection(timeSection)
                                        .font(.senti(size: 20))
                                        .gradientForeground()
                                }
                                
                                ForEach(getDataForSection(content: content, timeSection), id: \.self) { activity in
                                    let index = content.firstIndex(of: activity)!
                                    
                                    ZStack {
    //                                    NavigationLink { ActivityDetailView(activity: activity.activity, icon: activity.icon, description: activity.description, day: "Today", time: "10:05", duration: "10", sentiment: "happy", id: "") } label: {
                                            ZStack {
                                                ActivityBar(activity: activity.activity, description: activity.description, time: (DateFormatter.formatDate(date: activity.date, format: "HH:mm"), "10"), showsTime: !editing, sentiment: activity.sentiment, id: activity.id, icon: activity.icon)
                                                    .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.gray).opacity(0.2))
                                                    .shadow(radius: 10)
                                                RoundedRectangle(cornerRadius: 25).foregroundColor(.gray).opacity(editing ? 0.4 : 0)
                                            }
    //                                    }
                                        
                                        if editing {
                                            HStack {
                                                VStack {
                                                    if index > 0 {
                                                        Button {
                                                            withAnimation(.easeOut) {
                                                                (content[index-1], content[index]) = (content[index], content[index-1])
                                                            }
                                                        } label: {
                                                            Image(systemName: "arrow.up.circle")
                                                                .standardIcon(width: 35)
                                                                .gradientForeground()
                                                        }
                                                    }
                                                    if index < content.count-1 {
                                                        Button {
                                                            withAnimation(.easeOut) {
                                                                (content[index+1], content[index]) = (content[index], content[index+1])
                                                            }
                                                        } label: {
                                                            Image(systemName: "arrow.down.circle")
                                                                .standardIcon(width: 35)
                                                                .gradientForeground()
                                                        }
                                                    }
                                                }
                                                .padding(.leading, 25)
                                                
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.top)
                        }
                        .padding(.horizontal, 15)
                    }
                    .onAppear {
                        content = persistenceController.getEntriesOfDay(viewContext: viewContext, day: date)
                    }
            }
            DismissButton()
        }
//        }
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarHidden(true)
    }
}

struct CalendarDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDayDetailView(date: Date())
    }
}
