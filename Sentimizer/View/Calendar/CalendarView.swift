//
//  CalendarView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 26.04.22.
//

import SwiftUI
import CoreML

struct CalendarView: View {
    let data: [CalendarData]
    
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
        }.onAppear() {
            print("hi")
            let x:[[Float]] = [[0.2, 0.2], [0.5, 0.5]]
            
            let mlMultiArrayInput = try? MLMultiArray(shape:[1, 2], dataType:MLMultiArrayDataType.double)
            print("MLI", mlMultiArrayInput)
            mlMultiArrayInput![0] = NSNumber(floatLiteral: Double(0.42))
            mlMultiArrayInput![1] = NSNumber(floatLiteral: Double(0.0))
            // mlMultiArrayInput![2] = NSNumber(floatLiteral: Double(0))
            
            print("after", mlMultiArrayInput)
            
            let model = TestModel()
            
            let pred = try? model.prediction(input: TestModelInput(ip: mlMultiArrayInput!))
            print("pred", pred, pred?.var_6)
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

extension CalendarView {
    func getDaysInMonth() -> [(String, Date)] {
        let dateComponents = DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date))
        let calendar = Calendar.current
        
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        
        var dayDates: [Date] = []
        var count = 0
        for _ in range {
            dayDates.append(Calendar.current.date(byAdding: .day, value: count, to: Calendar.current.date(from: dateComponents)!)!)
            count += 1
        }
        
        var result: [(String, Date)] = []
        for i in range {
            result.append((String(i), dayDates[i-1]))
        }
        
        let dayNumber = Calendar.current.component(.weekday, from: date)-1
        for _ in 0..<dayNumber {
            result.insert(("", Date()), at: 0)
        }
        
        return result
    }
    
    func getActivityIconsForDay(date: Date) -> [String] {
        var icons: [String] = []
        for d in data {
            if Calendar.current.isDate(d.date, inSameDayAs: date) {
                icons.append(d.icon)
            }
        }
        return icons
    }
    
    func getActivitiesForDay(date: Date) -> [CalendarData] {
        var activities: [CalendarData] = []
        for d in data {
            if Calendar.current.isDate(d.date, inSameDayAs: date) {
                activities.append(d)
            }
        }
        return activities
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(data: [CalendarData(date: Date(), activity: "Walk", icon: "figure.walk"), CalendarData(date: Date(), activity: "School", icon: "suitcase.fill")])
    }
}
