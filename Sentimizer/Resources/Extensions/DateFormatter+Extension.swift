//
//  DateFormatter+Extension.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import Foundation

extension DateFormatter {
    static func formatDate(date: Date, format: String = "dd MM") -> String {
        let d = DateFormatter()
        d.dateFormat = format
        return d.string(from: date)
    }
}
