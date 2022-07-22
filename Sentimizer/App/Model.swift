//
//  Model.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 11.07.22.
//

import Foundation
import CoreData
import SwiftUI
import LocalAuthentication

class Model: ObservableObject {
    
    @Published var unlockScreenPresented = false
    @Published var authenticationPresented = false
    
    @Published var influenceImprovedMonth: ([String], [Double]) = ([], [])
    @Published var influenceImprovedYear: ([String], [Double]) = ([], [])
    @Published var influenceWorsenedMonth: ([String], [Double]) = ([], [])
    @Published var influenceWorsenedYear: ([String], [Double]) = ([], [])
    
    init() {
        let influenceMonth = PersistenceController.getInfluence(with: K.monthInfluence)
        let influenceYear = PersistenceController.getInfluence(with: K.yearInfluence)
        
        influenceImprovedMonth = influenceMonth.0
        influenceWorsenedMonth = influenceMonth.1
        influenceImprovedYear = influenceYear.0
        influenceWorsenedYear = influenceYear.1
    }
    
    func authenticate() {
        if !authenticationPresented && UserDefaults.standard.bool(forKey: K.appHasToBeUnlocked) {
            authenticationPresented = true
            unlockScreenPresented = true
            
            let context = LAContext()
            var error: NSError?
            let reason = "Please authenticate to show Sentimizer."
            
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                    if success {
                        DispatchQueue.main.async {
                            self.unlockScreenPresented = false
                        }
                    }
                }
            } else {
                authenticationPresented = false
                unlockScreenPresented = false
            }
        }
    }
    
    func updateInfluence(activities: FetchedResults<Activity>, _ viewContext: NSManagedObjectContext, persistenceController: PersistenceController) {
        DispatchQueue.global(qos: .userInitiated).async {
            let monthInfluence = StatisticsData.getInfluence(viewContext: viewContext, interval: K.timeIntervals[2], activities: activities)
            let yearInfluence = StatisticsData.getInfluence(viewContext: viewContext, interval: K.timeIntervals[3], activities: activities)
            DispatchQueue.main.async {
                self.influenceImprovedMonth = monthInfluence.0
                self.influenceWorsenedMonth = monthInfluence.1
                persistenceController.saveInfluence(with: K.monthInfluence, data: monthInfluence)
                
                self.influenceImprovedYear = yearInfluence.0
                self.influenceWorsenedYear = yearInfluence.1
                persistenceController.saveInfluence(with: K.yearInfluence, data: yearInfluence)
            }
        }
    }
}
