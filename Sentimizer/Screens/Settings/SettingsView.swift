//
//  SettingsView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 17.05.22.
//

import SwiftUI
import Crisp

struct SettingsView: View {

    @AppStorage(K.userNickname) private var userNickname = ""
    @State private var nicknameText = UserDefaults.standard.string(forKey: K.userNickname) ?? ""
    @State private var nicknameTextFieldEditing = false
    @FocusState private var nicknameTextFieldFocused: Bool
    
    @State private var colorScheme: K.AppColorScheme = Settings.getColorScheme()
    
    @State private var colorTheme = Settings.getColorTheme()
    
    @State private var showCrisp: Bool = false
    
    @AppStorage(K.appHasToBeUnlocked) private var appHasToBeUnlocked = false
    
    @State private var privacyPresented = false
    
    let haptic = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        ZStack {
            Color.bgColor.ignoresSafeArea()
            
            List {
                Section {
                    HStack {
                        Image(systemName: "person.fill")
                            .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2Light)
                        
                        ZStack {
                            SentiTextField(placeholder: "Your nickname", text: $nicknameText, textFieldEditing: $nicknameTextFieldEditing, done: .constant(false), textFieldFocus: _nicknameTextFieldFocused)
                                .disableAutocorrection(true)
                                .padding(.vertical, -10)
                                .padding(.leading)
                                .onChange(of: nicknameTextFieldEditing) { _ in
                                    userNickname = nicknameText
                                }
                            
                            HStack {
                                Spacer()
                                
                                if !nicknameTextFieldFocused {
                                    Button {
                                        withAnimation {
                                            nicknameTextFieldFocused = true
                                        }
                                    } label: {
                                        Image(systemName: "pencil")
                                            .standardIcon()
                                            .frame(height: 20)
                                            .padding(13)
                                            .standardBackground()
                                            .padding(.trailing)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Section {
                    NavigationLink {
                        ZStack {
                            Color.bgColor.ignoresSafeArea()
                            ActivityChooserView(activity: .constant(""), icon: .constant(""), redirectToEdit: true)
                                .padding(.top, -30)
                                .navigationBarTitleDisplayMode(.inline)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.rectangle.stack")
                                .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2)
                            Text("Edit Activity Categories")
                                .minimumScaleFactor(0.8)
                        }
                    }
                }
                
                Section(header: Text("Color Scheme").font(.senti(size: 13)).foregroundColor(.gray)) {
                    Button {
                        Settings.saveColorScheme(.light)
                        colorScheme = Settings.getColorScheme()
                        haptic.impactOccurred()
                    } label: {
                        HStack {
                            Image(systemName: "sun.max.fill")
                                .standardSentiSettingsIcon(foregroundColor: .gray, backgroundColor: .brandColor4)
                            Text("Light")
                            Spacer()
                            if(colorScheme == .light) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    Button {
                        Settings.saveColorScheme(.dark)
                        colorScheme = Settings.getColorScheme()
                        haptic.impactOccurred()
                    } label: {
                        HStack {
                            Image(systemName: "moon.stars")
                                .standardSentiSettingsIcon(foregroundColor: .gray, backgroundColor: .brandColor4)
                            Text("Dark")
                            Spacer()
                            if(colorScheme == .dark) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    Button {
                        Settings.saveColorScheme(.auto)
                        colorScheme = Settings.getColorScheme()
                        haptic.impactOccurred()
                    } label: {
                        HStack {
                            Image(systemName: "gearshape.fill")
                                .standardSentiSettingsIcon(foregroundColor: .gray, backgroundColor: .brandColor4)
                            Text("Auto")
                            Spacer()
                            if(colorScheme == .auto) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                Section(header: Text("Color Theme").font(.senti(size: 13)).foregroundColor(.gray)) {
                    Button {
                        Settings.saveColorTheme(true)
                        colorTheme = true
                        haptic.impactOccurred()
                    } label: {
                        HStack {
                            Image(systemName: "rays")
                                .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .purple)
                            Text("Purple")
                            Spacer()
                            if(colorTheme) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    Button {
                        Settings.saveColorTheme(false)
                        colorTheme = false
                        haptic.impactOccurred()
                    } label: {
                        HStack {
                            Image(systemName: "rays")
                                .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .green.adjust(brightness: -0.2))
                            Text("Green")
                            Spacer()
                            if(!colorTheme) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                Section {
                    Button {
                        appHasToBeUnlocked.toggle()
                        UserDefaults.standard.set(appHasToBeUnlocked, forKey: K.appHasToBeUnlocked)
                        haptic.impactOccurred()
                    } label: {
                        HStack {
                            Image(systemName: "lock.fill")
                                .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor1)
                            Text("Lock Sentimizer")
                            Spacer()
                            if(appHasToBeUnlocked) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                } footer: {
                    Text("Use Face ID / Touch ID to restrict access to Sentimizer.")
                        .font(.senti(size: 13))
                        .foregroundColor(.gray)
                }
                
                Section {
                    Button {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "text.bubble")
                                .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2)
                            Text("Language")
                            Spacer()
                        }
                    }
                }
                
                Section(header: Text("Other").font(.senti(size: 13)).foregroundColor(.gray)) {
                    HStack {
                        Image(systemName: "globe")
                            .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2, width: 17)
                        Link(destination: URL(string: "https://samuelgin.github.io/Sentimizer-Website/")!) {
                            Text("Our Website")
                                .font(.senti(size: 15))
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "hand.raised.fill")
                            .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2, width: 17)
                        Link(destination: URL(string: "https://samuelgin.github.io/Sentimizer-Website/privacy.html")!) {
                            Text("Privacy Policy")
                                .font(.senti(size: 15))
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Button(action: {
                            showCrisp.toggle()
                        }){
                        Image(systemName: "envelope.fill")
                            .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2, width: 17)
                        }
                        .sheet(isPresented:  $showCrisp, content:{
                            CrispUIViewControllerRepresentable()
                        })
                        
                            
                        Text("Feedback / Support")
                                .font(.senti(size: 15))
                        
                        Spacer()
                    }
                    
                    Text("""
                        1.1.1: This version of Sentimizer is still in beta. Some features may not be available yet.
                        Created by Samuel Ginsberg, Justin Hohenstein and Henry Pham. Smiley Icons made by Freepik from flaticon.com.
                        """)
                    .multilineTextAlignment(.leading)
                    .font(.senti(size: 12))
                    .foregroundColor(.gray)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .font(.senti(size: 20))
            .padding(.top, 5)
            .onAppear {
                colorTheme = Settings.getColorTheme()
            }
            .foregroundColor(.textColor)
            .sheet(isPresented: $privacyPresented) {
                PrivacyPolicy()
            }
        }
    }
}

struct CrispUIViewControllerRepresentable: UIViewControllerRepresentable{
    
    func makeUIViewController(context: Context) -> some UINavigationController {
        let vc = ChatViewController()
        return vc
    }
    
    func updateUIViewController(_ uiView: UIViewControllerType, context: Context) {
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

