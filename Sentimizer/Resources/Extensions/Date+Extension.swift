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
}

extension DateFormatter {
    static func formatDate(date: Date, format: String = "dd MM") -> String {
        let d = DateFormatter()
        d.dateFormat = format
        return d.string(from: date)
    }
}
