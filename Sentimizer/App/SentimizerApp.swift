//
//  SentimizerApp.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, Justin Hohenstein, Henry Pham, 2022.
//

import SwiftUI
import LocalAuthentication
import CoreData

@main
struct SentimizerApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    
    private let context = PersistenceController().container.viewContext
    
    @ObservedObject private var model = Model()
    
    @AppStorage(K.colorTheme) private var colorTheme = false
    
    @State private var unlockScreenPresented = false
    
    var body: some Scene {
        WindowGroup {
            AppTabNavigation()
                .font(.senti(size: 12))
                .foregroundColor(.textColor)
                .accentColor(colorTheme ? Color(.sRGB, red: 0.576, green: 0.490, blue: 0.762, opacity: 1) : Color(.sRGB, red: 0.224, green: 0.682, blue: 0.663, opacity: 1.0))
                .environmentObject(model)
                .environment(\.managedObjectContext, context)
                .navigationViewStyle(.stack)
                .fullScreenCover(isPresented: $unlockScreenPresented) {
                    LockScreen()
                        .environmentObject(model)
                }
                .onChange(of: model.unlockScreenPresented) { newValue in
                    unlockScreenPresented = newValue
                }
                .onAppear {
                    if let scheme = UserDefaults.standard.string(forKey: K.colorSchemeURL) {
                        Settings.setColorScheme(scheme == K.AppColorScheme.light.rawValue ? .light : (scheme == K.AppColorScheme.dark.rawValue ? .dark : .auto))
                    }
                    
                    model.authenticate()
                    
                    if let userId = UserDefaults.standard.string(forKey: K.userId) {
                        print(userId)
                    } else {
                        UserDefaults.standard.set(String.randomString(length: 10), forKey: K.userId)
                        UserDefaults.standard.set(true, forKey: K.colorTheme)
                    }
                }
                .onChange(of: scenePhase) { newValue in
                    if UserDefaults.standard.bool(forKey: K.appHasToBeUnlocked) {
                        if newValue == .inactive {
                            model.unlockScreenPresented = true
                        }
                        if newValue == .background {
                            model.authenticationPresented = false
                        }
                        if newValue == .active {
                            model.authenticate()
                        }
                    }
                }
        }
    }
    
}

struct LockScreen: View {
    @EnvironmentObject private var model: Model
    
    var body: some View {
        ZStack {
            Color.bgColor.ignoresSafeArea()
            
            VStack {
                Image(systemName: "lock.fill")
                    .standardIcon(shouldBeMaxWidthHeight: true, maxWidthHeight: 50)
                    .foregroundColor(.gray)
                    .padding()
                Button {
                    model.authenticationPresented = false
                    model.authenticate()
                } label: {
                    Text("Unlock Sentimizer")
                        .padding(10)
                        .font(.senti(size: 15))
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.brandColor2))
                }
            }
        }
        .navigationBarHidden(true)
    }
}
