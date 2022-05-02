//
//  DataController.swift
//  Sentimizer
//
//  Created by Justin Hohenstein on 29.04.22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Entry")
    
    init() {
        container.loadPersistentStores(completionHandler: {description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        })
    }
}
