//
//  DataController.swift
//  Sentimizer
//
//  Created by Justin Hohenstein on 29.04.22.
//

import SwiftUI
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Entry")
    
    init() {
        container.loadPersistentStores(completionHandler: {description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        })
    }
    
    static func getEntryData(entries: FetchedResults<Entry>) -> ([String], [[[String]]]) {
        var days: [String] = []
        var content: [[[String]]] = [[[]]]
        
        for entry in entries {
            var day = formatDate(date:entry.date!, format: "EEE, d MMM")
            
            if (Calendar.current.isDateInToday(entry.date!)) {
                day = "Today"
            } else if (Calendar.current.isDateInYesterday(entry.date!)) {
                day = "Yesterday"
            }
            
            if day != days.first {
                days.insert(day, at: 0)
                content.insert([], at: 0)
            }
            
            content[0].insert([entry.activity ?? "senting", formatDate(date: entry.date!, format: "HH:mm"), "10", entry.text ?? "", entry.feeling ?? "happy"], at:0)
        }
        return (days, content)
    }

    static func formatDate(date: Date, format: String = "dd MM") -> String {
        let d = DateFormatter()
        d.dateFormat = format
        return d.string(from: date)
    }
}
