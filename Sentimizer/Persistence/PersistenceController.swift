//
//  PersistenceController.swift
//  Sentimizer
//
//  Created by Justin Hohenstein on 29.04.22.
//

import SwiftUI
import CoreData

class PersistenceController: ObservableObject {
    private static var container: NSPersistentCloudKitContainer {
        let container = NSPersistentCloudKitContainer(name: "Model")
        container.loadPersistentStores(completionHandler: {description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }
    
    var context: NSManagedObjectContext {
        return PersistenceController.container.viewContext
    }
    
    //MARK: - Entity: Entry
    
    func getEntryData(entries: FetchedResults<Entry>, month: Date = Date()) -> ([String], [[[String]]]) {
        var days: [String] = []
        var content: [[[String]]] = []
        
        for entry in entries {
            if Calendar.current.isDate(entry.date!, equalTo: month, toGranularity: .month) {
                var day = DateFormatter.formatDate(date:entry.date!, format: "EEE, d MMM")
                
                if (Calendar.current.isDateInToday(entry.date!)) {
                    day = "Today"
                } else if (Calendar.current.isDateInYesterday(entry.date!)) {
                    day = "Yesterday"
                }
                
                if day != days.last {
                    days.append(day)
                    content.append([])
                }
                
                content[content.count - 1].append([entry.activity ?? "senting", DateFormatter.formatDate(date: entry.date!, format: "HH:mm"), "10", entry.text ?? "", entry.feeling ?? "happy", entry.objectID.uriRepresentation().absoluteString])
            }
        }
        
        return (days, content)
    }
    
    func getEntriesOfDay(viewContext: NSManagedObjectContext, day: Date) -> [ActivityData] {
        let fetchRequest: NSFetchRequest<Entry>
        fetchRequest = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        
        let entries = try! viewContext.fetch(fetchRequest)
        
        var results:[ActivityData] = []
        
        for entry in entries {
            if Calendar.current.isDate(entry.date!, inSameDayAs: day) {
                results.append(ActivityData(id: entry.objectID.uriRepresentation().absoluteString, activity: entry.activity!, icon: getActivityIcon(activityName: entry.activity!, viewContext), date: entry.date!, description: entry.description))
            }
        }
        
        try! viewContext.save()
        
        return results
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
    
    func saveActivity(activity: String, icon: String, description: String, feeling: String, date: Date, _ viewContext: NSManagedObjectContext) {
        let entry = Entry(context: viewContext)
        entry.text = description
        entry.date = Date() // Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 60 * 60 * 24 * 5.1)
        entry.feeling = feeling
        entry.activity = activity
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), save activity failed:")
            print(error.localizedDescription)
        }
        
        // hier musst du den entry an django senden und speichern
        // Das musst du in glaube ich in django speichern:
        print("Django: activity: \(activity) id \(entry.objectID.uriRepresentation().absoluteString) feeling \(SentiScoreHelper.getSentiScore(for: feeling)) datum \(Date())")
    }
    
    func deleteActivity(id: String, _ viewContext: NSManagedObjectContext) {
        let objectID = viewContext.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: URL(string: id)!)!
        
        let object = try! viewContext.existingObject(with: objectID)
        
        viewContext.delete(object)
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), delete activity failed:")
            print(error.localizedDescription)
        }
        
        // hier das Object mit der id id auf dem Server löschen
        
        print("Django: id ", id)
    }
    
    func getActivityIcon(activityName: String, _ viewContext: NSManagedObjectContext) -> String {
        let request = Activity.fetchRequest()
        
        do {
            let activities = try viewContext.fetch(request)
            
            for activity in activities {
                if activity.name! == activityName {
                    return activity.icon!
                }
            }
        } catch {
            print("In \(#function), line \(#line), get activity icon failed:")
            print(error.localizedDescription)
        }
        
        for i in 0..<K.defaultActivities.0.count {
            if K.defaultActivities.0[i] == activityName {
                return K.defaultActivities.1[i]
            }
        }
        
        return "figure.walk"
    }
    
    func updateMood(with mood: String, id: String, _ viewContext: NSManagedObjectContext) {
        let objectID = viewContext.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: URL(string: id)!)!
        
        let object = try! viewContext.existingObject(with: objectID)
        
        (object as! Entry).feeling = mood
        
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), update mood failed:")
            print(error.localizedDescription)
        }
    }
    
    func updateActivity(with activity: String, id: String, _ viewContext: NSManagedObjectContext) {
        let objectID = viewContext.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: URL(string: id)!)!
        
        let object = try! viewContext.existingObject(with: objectID)
        
        (object as! Entry).activity = activity
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), update activity failed:")
            print(error.localizedDescription)
        }
    }
    
    func updateActivityDescription(with description: String, id: String, _ viewContext: NSManagedObjectContext) {
        let objectID = viewContext.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: URL(string: id)!)!
        
        let object = try! viewContext.existingObject(with: objectID)
        
        (object as! Entry).text = description
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), save activity failed:")
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Entity: Activity (= Activity Category)
    func saveNewActivityCategory(name: String, icon: String, _ viewContext: NSManagedObjectContext) {
        let activity = Activity(context: viewContext)
        activity.name = name
        activity.icon = icon
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), save new activity category failed:")
            print(error.localizedDescription)
        }
    }
    
    func deleteActivityCategory(with categoryName: String, _ viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Activity>
        fetchRequest = Activity.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        
        let activities = try! viewContext.fetch(fetchRequest)
        
        for activity in activities {
            if activity.name == categoryName {
                viewContext.delete(activity)
            }
        }
        
        changeEntryCategories(viewContext: viewContext, oldName: categoryName)
        
        try! viewContext.save()
    }
    
    func activityCategoryNameAlreadyExists(for categoryName: String, _ viewContext: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<Activity>
        fetchRequest = Activity.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        
        let activities = try! viewContext.fetch(fetchRequest)
        
        for activity in activities {
            if categoryName.trimmingCharacters(in: .whitespacesAndNewlines).compare(activity.name!.trimmingCharacters(in: .whitespacesAndNewlines), options: .caseInsensitive) == .orderedSame {
                return true
            }
        }
        
        return false
    }
    
    func updateActivityCategoryName(with activityName: String, oldName: String, _ viewContext: NSManagedObjectContext) {
        print("an", activityName, "on", oldName)
    
        let fetchRequest: NSFetchRequest<Activity>
        fetchRequest = Activity.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        
        let activities = try! viewContext.fetch(fetchRequest)
        
        for activity in activities {
            if activity.name == oldName {
                activity.name = activityName
            }
        }
        
        changeEntryCategories(viewContext: viewContext, oldName: oldName, newName: activityName)
        
        try! viewContext.save()
    }
    
    func updateActivityCategoryIcon(with icon: String, activityName: String, _ viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Activity>
        fetchRequest = Activity.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        
        let activities = try! viewContext.fetch(fetchRequest)
        
        for activity in activities {
            if activity.name == activityName {
                activity.icon = icon
            }
        }
        
        try! viewContext.save()
    }
    
    //MARK: - Other
    func addSampleData(_ viewContext: NSManagedObjectContext) {
        let feelings = ["crying", "sad", "neutral", "content", "happy"]
        let activities = ["Walk", "Sport", "Hobby", "Friends", "Sleep"]
        
        for i in 0..<12 {
            for j in 0..<3 {
                let entry = Entry(context: viewContext)
                entry.text = "very important activity"
                entry.date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 60 * 60 * 24 * 3 * (Double(i) + Double(j) * 0.3))
                if i < feelings.count {
                    entry.feeling = feelings[i]
                    entry.activity = activities[i]
                } else {
                    entry.feeling = "happy"
                    entry.activity = "Sleep"
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
    
    func changeEntryCategories(viewContext: NSManagedObjectContext, oldName: String, newName: String = "Unspecified") {
        let fetchRequest: NSFetchRequest<Entry>
        fetchRequest = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        
        let entries = try! viewContext.fetch(fetchRequest)
        
        for entry in entries {
            if entry.activity == oldName {
                entry.activity = newName
            }
        }
    }
    
    //MARK: - User Defaults
    
    func saveInfluence(with key: String, for data: (([String], [Double]), ([String], [Double]))) {
        let defaults = UserDefaults.standard
        
        defaults.set(data.0.0, forKey: key + "i_name")
        defaults.set(data.0.1, forKey: key + "i_val")
        
        defaults.set(data.1.0, forKey: key + "w_name")
        defaults.set(data.1.1, forKey: key + "w_val")
    }
    
    func getInfluence(with key: String) -> (([String], [Double]), ([String], [Double])) {
        print("VALUE", key)
        let defaults = UserDefaults.standard
        
        var res: (([String], [Double]), ([String], [Double])) = (([], []), ([], []))
        
        if let iname = defaults.object(forKey: key + "i_name") as? [String] {
            res.0.0 = iname
        }
        if let ival = defaults.object(forKey: key + "i_val") as? [Double] {
            res.0.1 = ival
        }
            
        if let wname = defaults.object(forKey: key + "w_name") as? [String] {
            res.1.0 = wname
        }
        if let wval = defaults.object(forKey: key + "w_val") as? [Double] {
            res.1.1 = wval
        }
        
        return res
    }
}
