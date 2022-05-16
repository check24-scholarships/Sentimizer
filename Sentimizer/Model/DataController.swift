//
//  DataController.swift
//  Sentimizer
//
//  Created by Justin Hohenstein on 29.04.22.
//

import SwiftUI
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Model")
    
    init() {
        container.loadPersistentStores(completionHandler: {description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        })
    }
    
    static func getEntryData(entries: FetchedResults<Entry>) -> ([String], [[[String]]]) {
        var days: [String] = []
        var content: [[[String]]] = []
        
        for entry in entries {
            var day = formatDate(date:entry.date!, format: "EEE, d MMM")
            
            if (Calendar.current.isDateInToday(entry.date!)) {
                day = "Today"
            } else if (Calendar.current.isDateInYesterday(entry.date!)) {
                day = "Yesterday"
            }
            
            if day != days.last {
                days.append(day)
                content.append([])
            }
            
            content[content.count - 1].append([entry.activity ?? "senting", formatDate(date: entry.date!, format: "HH:mm"), "10", entry.text ?? "", entry.feeling ?? "happy", entry.objectID.uriRepresentation().absoluteString])
        }
        
        return (days, content)
    }

    static func formatDate(date: Date, format: String = "dd MM") -> String {
        let d = DateFormatter()
        d.dateFormat = format
        return d.string(from: date)
    }
    
    static func saveActivity(activity: String, icon: String, description: String, feeling: String, date: Date, viewContext: NSManagedObjectContext) {
        let entry = Entry(context: viewContext)
        entry.text = description
        entry.date = Date()
        entry.feeling = feeling
        entry.activity = activity
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), save activity failed:")
            print(error.localizedDescription)
        }
    }
    
    static func deleteActivity(viewContext: NSManagedObjectContext, id: String) {
        let objectID = viewContext.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: URL(string: id)!)!
        
        let object = try! viewContext.existingObject(with: objectID)
        
        viewContext.delete(object)
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), save activity failed:")
            print(error.localizedDescription)
        }
    }
    
    static func getSentiScore(for sentiment: String) -> Double{
        switch sentiment {
        case "crying":
            return 0
        case "sad":
            return 0.25
        case "neutral":
            return 0.5
        case "content":
            return 0.75
        case "happy":
            return 1
        default:
            return 0.5
        }
    }
    
    static func addSampleData(viewContext: NSManagedObjectContext) {
        let feelings = ["crying", "sad", "neutral", "content", "happy"]
        let activities = ["Walking", "Training", "Gaming", "Project Work", "Lunch"]
        
        for i in 0..<12 {
            for j in 0..<3 {
                let entry = Entry(context: viewContext)
                entry.text = "very important activity"
                entry.date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 60 * 60 * 24 * 31 * (Double(i) + Double(j) * 0.3))
                if i < feelings.count {
                    entry.feeling = feelings[i]
                    entry.activity = activities[i]
                } else {
                    entry.feeling = "happy"
                    entry.activity = "Project Work"
                }
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), save activity failed:")
            print(error.localizedDescription)
        }
    }
    
    static func deleteAllData(viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Entry>
        fetchRequest = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        
        let entries = try! viewContext.fetch(fetchRequest)
        
        for entry in entries {
            viewContext.delete(entry)
        }
        
        try! viewContext.save()
    }

    static func saveNewActivity(viewContext: NSManagedObjectContext,name: String, icon: String) {
        let activity = Activity(context: viewContext)
        activity.name = name
        activity.icon = icon
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), save activity failed:")
            print(error.localizedDescription)
        }
    }
    
    static func getActivityIcon(viewContext: NSManagedObjectContext, name: String) -> String {
        let request = Activity.fetchRequest()
        
        let activities = try? viewContext.fetch(request)
        
        for activity in activities! {
            print(activity.name!, name)
            if activity.name! == name {
                return activity.icon!
            }
        }
        
        for i in 0..<K.defaultActivities.0.count {
            if K.defaultActivities.0[i] == name {
                return K.defaultActivities.1[i]
            }
        }
        
        return "figure.walk"
    }
}
