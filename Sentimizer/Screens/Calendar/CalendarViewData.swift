//
//  CalendarViewData.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import SwiftUI

extension CalendarView {
    func getDaysInMonth() -> [(String, Date?)] {
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: selectedMonth), month: calendar.component(.month, from: selectedMonth))
        
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        
        var dayDates: [Date] = []
        var count = 0
        for _ in range {
            let newDate = calendar.date(byAdding: .hour, value: 10, to: date)!
            dayDates.append(calendar.date(byAdding: .day, value: count, to: newDate)!)
            count += 1
        }
        
        var result: [(String, Date?)] = []
        for i in range {
            result.append((String(i), dayDates[i-1]))
        }
        
        var dayNumber = calendar.component(.weekday, from: date)-2
        if dayNumber < 0 { dayNumber = 6 }
        for _ in 0..<dayNumber {
            result.insert(("", nil), at: 0)
        }
        
        return result
    }
    
    func getColorForDay(date: Date?) -> Color {
        K.sentimentColors[Int.random(in: 0...4)]
    }
}
