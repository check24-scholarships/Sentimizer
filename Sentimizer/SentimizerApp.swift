//
//  SentimizerApp.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, Justin Hohenstein, Henry Pham, 2022.
//

import SwiftUI

@main
struct SentimizerApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            //            MainActivityView()
            //                .environment(\.managedObjectContext, dataController.container.viewContext)
            
            AppTabNavigation()
                .environmentObject(Model())
                .font(.senti(size: 12))
                .minimumScaleFactor(0.8)
                .foregroundColor(.gray)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
