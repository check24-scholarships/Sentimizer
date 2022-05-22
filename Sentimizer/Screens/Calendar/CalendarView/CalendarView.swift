//
//  CalendarView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 26.04.22.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var dataController = DataController()
    
    let data: [CalendarModel]
    
    let sevenColumnGrid = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    var date = Date()
    var month: String {
        Calendar.current.monthSymbols[Calendar.current.component(.month, from: date)-1]
    }
    
    @State private var tappedDate = Date()
    @State private var daySheetPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            //            Text(month + " \(Calendar.current.component(.year, from: date))")
            //                .font(.senti(size: 35))
            //                .gradientForeground()
            //                .padding()
            
            WeekDays()
                .padding(.bottom, 5)
            
            ScrollView {
                LazyVGrid(columns: sevenColumnGrid) {
                    ForEach(0..<getDaysInMonth().count, id: \.self) { index in
                        HStack {
                            Spacer()
                            VStack {
                                ForEach(getActivityIconsForDay(date: getDaysInMonth()[index].1), id: \.self) { icon in
                                    Image(systemName: icon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 12)
                                }
                            }
                            .offset(x: 5)
                            
                            HStack {
                                Text(getDaysInMonth()[index].0)
                                    .lineLimit(1)
                            }
                            .padding(.bottom, 70)
                        }
                        .onTapGesture {
                            tappedDate = getDaysInMonth()[index].1
                            daySheetPresented = true
                        }
                    }
                }
                .padding(.trailing, 3)
            }
        }
        .padding(.top, 5)
        .navigationTitle(month + " \(Calendar.current.component(.year, from: date))")
        .sheet(isPresented: $daySheetPresented) {
            CalendarDayDetailView(data: getActivitiesForDay(date: tappedDate), date: tappedDate)
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
                //                    .foregroundColor(.white)
                    .font(.senti(size: 15))
                    .minimumScaleFactor(0.7)
                Spacer()
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(data: [CalendarModel(date: Date(), activity: "Walk", icon: "figure.walk"), CalendarModel(date: Date(), activity: "School", icon: "suitcase.fill")])
    }
}
