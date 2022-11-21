//
//  CalendarDayDetailView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 18.05.22.
//

import SwiftUI

struct CalendarDayDetailView: View {
    @Binding var date: Date
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject private var persistenceController = PersistenceController()
    
    @State private var editing = false
    
    @State private var selectedDayIndex = 0
    var selectedDay: Date {
        return getDaysInWeek()[selectedDayIndex]
    }
    
    @State private var brandColor2 = Color.brandColor2
    @State private var brandColor2Light = Color.brandColor2Light
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                VStack {
                    Image(systemName: "poweron")
                        .rotationEffect(Angle(degrees: 90))
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding(-5)
                    
                    TabView(selection: $selectedDayIndex) {
                        ForEach(0..<getDaysInWeek().count, id: \.self) { index in
                            let currentDay = getDaysInWeek()[index]
                            ScrollView {
                                VStack(spacing: 0) {
                                    let content = getContent(for: currentDay)
                                    
                                    DayList(content: content, day: currentDay, editing: $editing)
                                }
                            }
                            .padding(.top)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .onAppear {
                        selectedDayIndex = getDaysInWeek().firstIndex(of: date) ?? 0
                    }
                }
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .padding([.leading, .top])
            }
            .navigationBarHidden(true)
            .onAppear {
                brandColor2 = Color.brandColor2
                brandColor2Light = Color.brandColor2Light
            }
        }
    }
    
    func getContent(for day: Date) -> [ActivityData] {
        return persistenceController.getEntriesOfDay(viewContext: viewContext, day: day)
    }
}

struct DayList: View {
    let content: [ActivityData]
    let day: Date
    @Binding var editing: Bool
    
    @State private var brandColor2 = Color.brandColor2
    @State private var brandColor2Light = Color.brandColor2Light
    
    var body: some View {
        HStack(alignment: .top) {
            ViewTitle(LocalizedStringKey(getDayTitle(for: day)), padding: false)
                .padding(.top, 10)
                .frame(maxWidth: .infinity)
                .padding(.leading)
            
            Spacer()
            
            //                                    if content.count > 0 {
            //                                        Button {
            //                                            withAnimation {
            //                                                editing.toggle()
            //                                            }
            //                                        } label: {
            //                                            VStack {
            //                                                if !editing {
            //                                                    Image(systemName: "list.number")
            //                                                        .standardIcon(width: 25)
            //                                                        .frame(height: 25)
            //                                                        .padding(13)
            //                                                        .standardBackground()
            //                                                }
            //                                                Text(editing ? "Done" : "Edit order")
            //                                                    .bold()
            //                                                    .padding(editing ? 20 : 0)
            //                                                    .font(.senti(size: editing ? 20 : 12))
            //                                            }
            //                                            .padding(.trailing)
            //                                        }
            //                                    }
        }
        .padding(.top, 25)
        
        if content.count < 1 {
            Text("There are no entries for this day. Add entries or choose another.")
                .font(.senti(size: 15))
                .padding()
        }
        
        VStack(alignment: .leading, spacing: 0) {
            ForEach(K.timeSections, id: \.self) { timeSection in
                
                if CalendarDayDetailView.getDataForSection(content: content, timeSection).count > 0 {
                    CalendarDayDetailView.getTitleForSection(timeSection)
                        .font(.senti(size: 20))
                        .gradientForeground(colors: [brandColor2, brandColor2Light])
                }
                
                ForEach(CalendarDayDetailView.getDataForSection(content: content, timeSection), id: \.self) { activity in
                    let index = content.firstIndex(of: activity) ?? 0
                    let time = DateFormatter.formatDate(date: activity.date, format: "HH:mm")
                    
                    ZStack {
                        //                                                NavigationLink { ActivityDetailView(activity: activity.activity, icon: activity.icon, description: activity.description, day: LocalizedStringKey(DateFormatter.formatDate(date: activity.date, format: "EEE, d MMM")), time: time, duration: "10", sentiment: "happy", id: activity.id) } label: {
                        ZStack {
                            ActivityBar(activity: activity, activityName: LocalizedStringKey(activity.activity), time: time, showsTime: !editing)
                                .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.gray).opacity(0.2))
                                .shadow(radius: 10)
                            RoundedRectangle(cornerRadius: 25).foregroundColor(.gray).opacity(editing ? 0.4 : 0)
                        }
                        //                                                }
                        
                        if editing {
                            ChangeOrderArrows(index: index, content: content)
                        }
                    }
                }
            }
            .padding(.top)
        }
        .padding(.horizontal, 15)
        .onAppear {
            brandColor2 = Color.brandColor2
            brandColor2Light = Color.brandColor2Light
        }
    }
    
    func getDayTitle(for day: Date) -> String {
        return "\(DateFormatter.formatDate(date: day, format: "EE")), \(DateFormatter.formatDate(date: day, format: "d. MMM"))"
    }
    
    
}

struct ChangeOrderArrows: View {
    let index: Int
    let content: [ActivityData]
    
    @State private var brandColor2 = Color.brandColor2
    @State private var brandColor2Light = Color.brandColor2Light
    
    var body: some View {
        HStack {
            VStack {
                if index > 0 {
                    Button {
                        withAnimation(.easeOut) {
                            //                                                                        (content[index-1], content[index]) = (content[index], content[index-1])
                            changeOrderOf(activity: content[index-1], and: content[index])
                        }
                    } label: {
                        Image(systemName: "arrow.up.circle")
                            .standardIcon(width: 35)
                            .gradientForeground(colors: [brandColor2, brandColor2Light])
                    }
                }
                if index < content.count-1 {
                    Button {
                        withAnimation(.easeOut) {
                            //                                                                        (content[index+1], content[index]) = (content[index], content[index+1])
                            changeOrderOf(activity: content[index+1], and: content[index])
                        }
                    } label: {
                        Image(systemName: "arrow.down.circle")
                            .standardIcon(width: 35)
                            .gradientForeground(colors: [brandColor2, brandColor2Light])
                    }
                }
            }
            .padding(.leading, 25)
            .onAppear {
                brandColor2 = Color.brandColor2
                brandColor2Light = Color.brandColor2Light
            }
            
            Spacer()
        }
    }
    
    func changeOrderOf(activity: ActivityData, and activity2: ActivityData) {
        
    }
}

struct CalendarDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDayDetailView(date: .constant(Date()))
    }
}
