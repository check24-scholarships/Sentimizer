//
//  SentimizerApp.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, Justin Hohenstein, Henry Pham, 2022.
//

import SwiftUI

@main
struct SentimizerApp: App {
    var body: some Scene {
        WindowGroup {
            AppTabNavigation()
                .environmentObject(Model())
                .font(.senti(size: 12))
                .foregroundColor(.gray)
        }
    }
}
