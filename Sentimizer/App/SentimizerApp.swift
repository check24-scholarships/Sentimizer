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
    @State private var unlockScreenPresented = false
    @State private var authenticationPresented = false
    
    private let context = PersistenceController().container.viewContext
    
    @ObservedObject private var model = Model()
    
    @AppStorage(K.colorTheme) private var colorTheme = false
    
    var body: some Scene {
        WindowGroup {
            AppTabNavigation()
                .font(.senti(size: 12))
                .foregroundColor(.textColor)
                .accentColor(colorTheme ? Color(.sRGB, red: 0.576, green: 0.490, blue: 0.762, opacity: 1) : Color(.sRGB, red: 0.224, green: 0.682, blue: 0.663, opacity: 1.0))
                .environmentObject(model)
                .environment(\.managedObjectContext, context)
                .fullScreenCover(isPresented: $unlockScreenPresented) {
                    ZStack {
                        Color.bgColor.ignoresSafeArea()
                        
                        VStack {
                            Image(systemName: "lock.fill")
                                .standardIcon(shouldBeMaxWidthHeight: true, maxWidthHeight: 50)
                                .foregroundColor(.gray)
                                .padding()
                            Button {
                                authenticationPresented = false
                                authenticate()
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
                .onAppear {
                    // let rnn = K.rnn
                    
                    // rnn.trainNets()
                    
                    // print("HERERR", rnn.validNets())
                    
                    // MachineLearning.getModel()
                    
                    // MachineLearning.getTorch()
                    
                    print("HELP ME", MachineLearning.feedforward(ip: [0.1, 0.2, 0.3, 0.4]))
                    
                    if let scheme = UserDefaults.standard.string(forKey: K.colorSchemeURL) {
                        Settings.setColorScheme(scheme == K.AppColorScheme.light.rawValue ? .light : (scheme == K.AppColorScheme.dark.rawValue ? .dark : .auto))
                    }
                    
                    authenticate()
                    
                    if let userId = UserDefaults.standard.string(forKey: K.userId) {
                        print(userId)
                    } else {
                        UserDefaults.standard.set(String.randomString(length: 10), forKey: K.userId)
                    }
                }
                .onChange(of: scenePhase) { newValue in
                    if UserDefaults.standard.bool(forKey: K.appHasToBeUnlocked) {
                        if newValue == .inactive {
                            unlockScreenPresented = true
                        }
                        if newValue == .background {
                            authenticationPresented = false
                        }
                        if newValue == .active {
                            authenticate()
                        }
                    }
                }
        }
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
                        unlockScreenPresented = false
                    }
                }
            } else {
                authenticationPresented = false
                unlockScreenPresented = false
            }
        }
    }
}
