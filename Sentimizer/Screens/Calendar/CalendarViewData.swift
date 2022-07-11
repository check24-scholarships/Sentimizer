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
        
        let date = calendar.date(from: dateComponents) ?? Date()
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        
        var dayDates: [Date] = []
        var count = 0
        for _ in range {
            let newDate = calendar.date(byAdding: .hour, value: 10, to: date) ?? Date()
            dayDates.append(calendar.date(byAdding: .day, value: count, to: newDate) ?? Date())
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
    
    func getColorForDay(entries: FetchedResults<Entry>, date: Date?) -> Color {
        var average = 0.0
        var count = 0.0
        
        if entries.count == 0 {
            return .clear
        }
        
        for entry in entries {
            if Calendar.current.isDate(entry.date ?? Date.distantPast, equalTo: date ?? Date.distantFuture, toGranularity: .day) {
                average += SentiScoreHelper.getSentiScore(for: entry.feeling ?? "happy")
                count += 1
            }
        }
        
        average /= count
        
        switch average {
        case 0...0.2:
            return K.sentimentColors[0]
        case 0.2...0.4:
            return K.sentimentColors[1]
        case 0.4...0.6:
            return K.sentimentColors[2]
        case 0.6...0.8:
            return K.sentimentColors[3]
        case 0.8...1.0:
            return K.sentimentColors[4]
        default:
            return .clear
        }
    }
}
