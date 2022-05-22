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
            AppTabNavigation()
                .font(.senti(size: 12))
                .foregroundColor(K.textColor)
//                .environmentObject(Model())
                .environment(\.managedObjectContext, dataController.context)
                .onAppear() {
                     MachineLearning.getModel()
                }
        }
    }
}
