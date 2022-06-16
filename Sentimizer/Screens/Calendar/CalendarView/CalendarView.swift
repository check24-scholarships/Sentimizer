//
//  CalendarView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 26.04.22.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.managedObjectContext) var viewContext
    @StateObject private var persistenceController = PersistenceController()
    
    let sevenColumnGrid = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    let date = Date()
    @State var selectedMonth = Date()
    
    @State private var tappedDate = Date()
    @State private var daySheetPresented = false
    
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
                                        .foregroundColor(getColorForDay(date: days[index].1).opacity(0.1))
                                        .frame(width: 30, height: 30)
                                    )
                                .padding(.top)
                            
                            Spacer()
                            
                            VStack {
                                let icons = persistenceController.getActivityIconsForDay(viewContext: viewContext, date: days[index].1)
                                ForEach(0..<icons.count, id: \.self) { index in
                                    Image(systemName: icons[index])
                                        .standardIcon(shouldBeMaxWidthHeight: true, maxWidthHeight: 18)
                                        .gradientForeground()
                                        .padding(.bottom, 5)
                                }
                            }
                            .offset(x: 5)
                            
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background((((index+1)%7 == 0 || index%7 == 0) ?
                                     Color.brandColor2Light.opacity(0.3)
                                     : .clear).ignoresSafeArea().padding(.top, -8))
                        .onTapGesture {
                            if let date = getDaysInMonth()[index].1 {
                                tappedDate = date
                                daySheetPresented = true
                            }
                        }
                    }
                }
                .padding([.top, .trailing], 3)
            }
        }
        .padding(.top, 5)
        .padding(.bottom)
        .sheet(isPresented: $daySheetPresented) {
            CalendarDayDetailView(date: tappedDate)
        }
        .onAppear() {
//            print(MachineLearning.feedforward(ip: [0.2, 0.2, 0.2, 0.4]))
        }
    }
}

//MARK: - WeekDays View
struct WeekDays: View {
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
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
