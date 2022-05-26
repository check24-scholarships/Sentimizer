//
//  CalendarView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 26.04.22.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var persistenceController = PersistenceController()
    
    let data: [ActivityData]
    
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
                        VStack {
                            HStack {
                                Text(getDaysInMonth()[index].0)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            VStack {
                                ForEach(getActivityIconsForDay(date: getDaysInMonth()[index].1), id: \.self) { icon in
                                    Image(systemName: icon)
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
                            tappedDate = getDaysInMonth()[index].1
                            daySheetPresented = true
                        }
                    }
                }
                .padding([.top, .trailing], 3)
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
        CalendarView(data: [ActivityData(id: "", activity: "Walk", icon: "figure.walk", date: Date(), description: ""), ActivityData(id: "", activity: "Walk", icon: "figure.walk", date: Date(), description: "")])
    }
}
