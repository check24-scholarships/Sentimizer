//
//  CalendarViewData.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import Foundation

extension CalendarView {
    func getDaysInMonth() -> [(String, Date?)] {
        let dateComponents = DateComponents(year: Calendar.current.component(.year, from: selectedMonth), month: Calendar.current.component(.month, from: selectedMonth))
        let calendar = Calendar.current
        
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        
        var dayDates: [Date] = []
        var count = 0
        for _ in range {
            dayDates.append(Calendar.current.date(byAdding: .day, value: count, to: Calendar.current.date(from: dateComponents)!)!)
            count += 1
        }
        
        var result: [(String, Date?)] = []
        for i in range {
            result.append((String(i), dayDates[i-1]))
        }
        
        let dayNumber = Calendar.current.component(.weekday, from: date)-1
        for _ in 0..<dayNumber {
            result.insert(("", nil), at: 0)
        }
        
        return result
    }
    
    func getActivityIconsForDay(date: Date?) -> [String] {
        var icons: [String] = []
        for d in data {
            if icons.count < 2 {
                if let date = date, Calendar.current.isDate(d.date, inSameDayAs: date) {
                    icons.append(d.icon)
                } else {
                    icons.append("")
                }
            }
        }
        return icons
    }
    
    func getActivitiesForDay(date: Date) -> [ActivityData] {
        var activities: [ActivityData] = []
        for d in data {
            if Calendar.current.isDate(d.date, inSameDayAs: date) {
                activities.append(d)
            }
        }
        return activities
    }
}
