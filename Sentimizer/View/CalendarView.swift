//
//  CalendarView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 26.04.22.
//

import SwiftUI

struct CalendarView: View {
    
    let sevenColumnGrid = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    var date = Date()
    var month: String {
        Calendar.current.monthSymbols[Calendar.current.component(.month, from: date)-1]
    }
    	
    var body: some View {
        VStack(alignment: .leading) {
            Text(month + " \(Calendar.current.component(.year, from: date))")
                .font(.senti(size: 35))
                .gradientForeground()
                .padding()
            
            WeekDays()
                .padding(.bottom, 5)
            
            ScrollView {
                LazyVGrid(columns: sevenColumnGrid) {
                    ForEach(0..<getDaysInMonth().count, id: \.self) { index in
                        HStack {
                            Spacer()
                            Text(getDaysInMonth()[index].0)
                                .padding(.bottom, 70)
                        }
                    }
                }
            }
        }
        .navigationTitle("Calendar")
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
//        .background {
//            RoundedRectangle(cornerRadius: 25)
//                .foregroundColor(.gray.opacity(0.7))
//        }
    }
}

extension CalendarView {
    func getDaysInMonth() -> [(String, UUID)] {
        let dateComponents = DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date))
        let calendar = Calendar.current
        
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        
        let array = Array(range)
        var stringArray = array.map { (String($0), UUID()) }
        
        let dayNumber = Calendar.current.component(.weekday, from: date)-1
        for _ in 0..<dayNumber {
            stringArray.insert(("", UUID()), at: 0)
        }
        
        return stringArray
    }
    
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
