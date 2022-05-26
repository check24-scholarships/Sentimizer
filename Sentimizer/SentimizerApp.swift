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
                .foregroundColor(.textColor)
            //                .environmentObject(Model())
                .environment(\.managedObjectContext, dataController.context)
                .onAppear() {
                    MachineLearning.getModel()
                }
                .onAppear {
                    if let scheme = UserDefaults.standard.string(forKey: K.colorSchemeURL) {
                        Settings.setColorScheme(scheme == K.AppColorScheme.light.rawValue ? .light : (scheme == K.AppColorScheme.dark.rawValue ? .dark : .auto))
                    }
                }
        }
    }
}
