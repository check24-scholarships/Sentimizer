//
//  Date+Extension.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import Foundation

extension Date {
    static func appendMonths(to date: Date, count: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.month = count
        return Calendar.current.date(byAdding: dateComponent, to: date)!
    }
    
    static func appendDays(to date: Date, count: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = count
        return Calendar.current.date(byAdding: dateComponent, to: date)!
    }
    
    static func getTimeOfDay() -> K.timeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour > 3 && hour < 12 {
            return .morning
        } else if hour >= 12 && hour < 17 {
            return .afternoon
        }
        return .evening
    }
}

extension DateFormatter {
    static func formatDate(date: Date, format: String = "dd MM") -> String {
        let d = DateFormatter()
        d.dateFormat = format
        return d.string(from: date)
    }
}
