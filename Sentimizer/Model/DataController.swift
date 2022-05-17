//
//  DataController.swift
//  Sentimizer
//
//  Created by Justin Hohenstein on 29.04.22.
//

import SwiftUI
import CoreData

class DataController: ObservableObject {
    private static var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: {description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        })
        return container
    }
    
    var context: NSManagedObjectContext {
        return DataController.container.viewContext
    }
    
    func getEntryData(entries: FetchedResults<Entry>) -> ([String], [[[String]]]) {
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

    func formatDate(date: Date, format: String = "dd MM") -> String {
        let d = DateFormatter()
        d.dateFormat = format
        return d.string(from: date)
    }
    
    func saveActivity(activity: String, icon: String, description: String, feeling: String, date: Date, viewContext: NSManagedObjectContext) {
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
    
    func deleteActivity(viewContext: NSManagedObjectContext, id: String) {
        let objectID = viewContext.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: URL(string: id)!)!
        
        let object = try! viewContext.existingObject(with: objectID)
        
        viewContext.delete(object)
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), delete activity failed:")
            print(error.localizedDescription)
        }
    }
    
    func getSentiScore(for sentiment: String) -> Double{
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
    
    func getSentiIndex(for sentiment: String) -> Int {
        switch sentiment {
        case "crying":
            return 0
        case "sad":
            return 1
        case "neutral":
            return 2
        case "content":
            return 3
        case "happy":
            return 4
        default:
            return 0
        }
    }
    
    func addSampleData(viewContext: NSManagedObjectContext) {
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
    
    func deleteAllData(viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Entry>
        fetchRequest = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        
        let entries = try! viewContext.fetch(fetchRequest)
        
        for entry in entries {
            viewContext.delete(entry)
        }
        
        try! viewContext.save()
    }

    func saveNewActivity(viewContext: NSManagedObjectContext,name: String, icon: String) {
        let activity = Activity(context: viewContext)
        activity.name = name
        activity.icon = icon
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), save new activity failed:")
            print(error.localizedDescription)
        }
    }
    
    func getActivityIcon(viewContext: NSManagedObjectContext, name: String) -> String {
        let request = Activity.fetchRequest()
        
        do {
            let activities = try viewContext.fetch(request)
            
            for activity in activities {
                if activity.name! == name {
                    return activity.icon!
                }
            }
        } catch {
            print("In \(#function), line \(#line), get activity icon failed:")
            print(error.localizedDescription)
        }
        
        for i in 0..<K.defaultActivities.0.count {
            if K.defaultActivities.0[i] == name {
                return K.defaultActivities.1[i]
            }
        }
        
        return "figure.walk"
    }
    
    func getCount(viewContext: NSManagedObjectContext, interval: String) -> [Double] {
        let request = Entry.fetchRequest()
        var count:[Double] = [0.1, 0.1, 0.1, 0.1, 0.1]
        var lastTime: Double = 0
        
        if interval == K.timeIntervals[0] {
            lastTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!.timeIntervalSince1970
        } else if interval == K.timeIntervals[1] {
            lastTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!.timeIntervalSince1970 - (60 * 60 * 24 * 6)
        } else if interval == K.timeIntervals[2] {
            lastTime = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: Date())))!.timeIntervalSince1970
        } else if interval == K.timeIntervals[3] {
            lastTime = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: 1, day: 1))!.timeIntervalSince1970
        }
        
        do {
            let entries = try viewContext.fetch(request)
            
            for entry in entries {
                if entry.date!.timeIntervalSince1970 > lastTime {
                    count[getSentiIndex(for: entry.feeling!)] += 1
                }
            }
        } catch {
            print("In \(#function), line \(#line), get mood count failed:")
            print(error.localizedDescription)
        }
        
        return count
    }
    
    static func getInfluence(viewContext: NSManagedObjectContext, interval: String) -> (([String], [Double]), ([String], [Double])){
        let neuralNetwork = NeuralNetwork(arch: [2, 3, 2], data: [[[1, 0], [0, 0]]])
        
        let request = Entry.fetchRequest()
        var lastTime:Double = 0
        
        if interval == K.timeIntervals[0] {
            lastTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!.timeIntervalSince1970
        } else if interval == K.timeIntervals[1] {
            lastTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!.timeIntervalSince1970 - (60 * 60 * 24 * 6)
        } else if interval == K.timeIntervals[2] {
            lastTime = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: Date())))!.timeIntervalSince1970
        } else if interval == K.timeIntervals[3] {
            lastTime = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: 1, day: 1))!.timeIntervalSince1970
        }
        
        do {
            let entries = try viewContext.fetch(request)
            
            for entry in entries {
                // print("et", entry.date!)
            }
        } catch {
            print("In \(#function), line \(#line), save activity failed:")
            print(error.localizedDescription)
        }
        
        // neuralNetwork.feedforward(input: [0.2, 0.3])
        
        for i in 0 ..< 100 {
            neuralNetwork.backpropagtion()
            neuralNetwork.updateParams(div: 1)
        }
        
        return ((["Soccer"], [0.5]), (["Project"], [0.2]))
    }
}
