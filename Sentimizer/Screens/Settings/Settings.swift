//
//  Settings.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 26.05.22.
//

import SwiftUI

struct Settings {
    static func saveColorScheme(_ scheme: K.AppColorScheme) {
        UserDefaults.standard.set(scheme.rawValue, forKey: K.colorSchemeURL)
        
        setColorScheme(scheme)
    }
    
    static func setColorScheme(_ scheme: K.AppColorScheme) {
        (UIApplication.shared.connectedScenes.first as?
         UIWindowScene)?.windows.first!.overrideUserInterfaceStyle = scheme == .dark ? .dark : (scheme == .light ? .light : .unspecified)
    }
    
    static func getColorScheme() -> K.AppColorScheme {
        if let scheme = UserDefaults.standard.string(forKey: K.colorSchemeURL) {
            return scheme == K.AppColorScheme.light.rawValue ? .light : (scheme == K.AppColorScheme.dark.rawValue ? .dark : .auto)
        }
        return .auto
    }
}
