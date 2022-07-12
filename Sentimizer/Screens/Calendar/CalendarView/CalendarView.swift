//
//  CalendarView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 26.04.22.
//

import SwiftUI
import CoreData

struct CalendarView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject private var persistenceController = PersistenceController()
    
    let sevenColumnGrid = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    let date = Date()
    @State var selectedMonth = Date()
    
    @State private var tappedDate = Date()
    @State private var daySheetPresented = false
    
    @FetchRequest private var entries: FetchedResults<Entry>
    
    var body: some View {
        VStack(alignment: .leading) {
            MonthSwitcher(selectedMonth: $selectedMonth)
            
            WeekDays()
                .padding(.bottom, 5)
            
            ScrollView {
                LazyVGrid(columns: sevenColumnGrid) {
                    let days = getDaysInMonth()
                    ForEach(0..<days.count, id: \.self) { index in
                        VStack {
                            Text(getDaysInMonth()[index].0)
                                .lineLimit(1)
                                .foregroundColor(.primary)
                                .overlay(
                                    Circle()
                                        .foregroundColor(getColorForDay(entries: entries, date: days[index].1).opacity(0.1))
                                        .frame(width: 30, height: 30)
                                )
                                .padding(.top)
                            
                            Spacer()
                            
                            VStack {
                                if persistenceController.iconsForDay.count > index {
                                    ForEach(0..<persistenceController.iconsForDay[index].count, id: \.self) { i in
                                        Image(systemName: persistenceController.iconsForDay[index][i])
                                            .standardIcon(shouldBeMaxWidthHeight: true, maxWidthHeight: 18)
                                            .gradientForeground()
                                            .padding(.bottom, 5)
                                            .offset(x: -3, y: 2)
                                    }
                                }
                            }
                            .offset(x: 5)
                            
                            Spacer()
                            
                            Divider()
                            
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background((Color.brandColor2Light.opacity(((index+2)%7 == 0 || (index+1)%7 == 0) ? 0.2 : 0.05))
                            .ignoresSafeArea()
                            .padding(.top, -8)
                            .onTapGesture(perform: {
                                if let date = getDaysInMonth()[index].1 {
                                    tappedDate = date
                                    daySheetPresented = true
                                }
                            }))
                    }
                }
                .padding([.top, .trailing], 3)
            }
            .padding(.bottom)
        }
        .padding(.top, 5)
        .sheet(isPresented: $daySheetPresented) {
            CalendarDayDetailView(date: $tappedDate)
        }
        .onAppear {
            //            print(MachineLearning.feedforward(ip: [0.2, 0.2, 0.2, 0.4]))
            getIcons()
        }
        .onChange(of: selectedMonth) { newValue in
            getIcons()
        }
    }
    
    init() {
        let f: NSFetchRequest<Entry> = Entry.fetchRequest()
        f.sortDescriptors = [NSSortDescriptor(key: #keyPath(Entry.date), ascending: false)]
        _entries = FetchRequest(fetchRequest: f)
    }
    
    func getIcons() {
        var days: [Date?] = []
        for day in getDaysInMonth() {
            days.append(day.1)
        }
        persistenceController.getActivityIconsForDays(viewContext: viewContext, dates: days)
    }
}

//MARK: - WeekDays View
struct WeekDays: View {
    let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<7, id: \.self) { index in
                Spacer()
                Text(weekDays[index])
                    .bold()
                    .foregroundColor(.brandColor2)
                    .font(.senti(size: 15))
                    .minimumScaleFactor(0.7)
                Spacer()
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
