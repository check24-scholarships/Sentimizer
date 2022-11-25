//
//  SettingsView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 17.05.22.
//

import SwiftUI
import Crisp

struct SettingsView: View {
    
    let haptic = UIImpactFeedbackGenerator(style: .light)
    
    @AppStorage(K.userNickname) private var userNickname = ""
    @State private var nicknameText = UserDefaults.standard.string(forKey: K.userNickname) ?? ""
    @State private var nicknameTextFieldEditing = false
    @FocusState private var nicknameTextFieldFocused: Bool
    

    
    @State private var crispPresented: Bool = false
    
    @State private var colorThemePresented: Bool = false
    
    @AppStorage(K.appHasToBeUnlocked) private var appHasToBeUnlocked: Bool = false
    
    @State private var privacyPresented: Bool = false
    
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
                                .font(.sentiMedium(size: 17))
                            Image(systemName: "chevron.forward")
                        }
                    }
                }
                
                Section{
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
                                .font(.sentiMedium(size: 17))
                            Spacer()
                        }
                    }
                    Button {
                        haptic.impactOccurred()
                        colorThemePresented.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "rays")
                                .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2)
                            Text("Theme")
                                .font(.sentiMedium(size: 17))
                                .sheet(isPresented:  $colorThemePresented) {
                                    SettingsColorThemeView()
                                }
                            
                            Spacer()
                            Image(systemName: "chevron.forward")
                        }
                    }
                } header: {
                    Text("General")
                        .font(.sentiLight(size: 13))
                        .foregroundColor(.gray)
                }
                
                Section{
                    Button {
                        appHasToBeUnlocked.toggle()
                        UserDefaults.standard.set(appHasToBeUnlocked, forKey: K.appHasToBeUnlocked)
                        haptic.impactOccurred()
                    } label: {
                        HStack {
                            Image(systemName: "lock.fill")
                                .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2)
                            Text("Lock Sentimizer")
                                .font(.sentiMedium(size: 17))
                            Spacer()
                            if(appHasToBeUnlocked) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                } header: {
                    Text("Privacy")
                        .font(.sentiLight(size:13))
                        .foregroundColor(.gray)
                } footer: {
                    Text("Use Face ID / Touch ID to restrict access to Sentimizer.")
                        .font(.sentiLight(size: 13))
                        .foregroundColor(.gray)
                }
                
                Section {
                    HStack {
                        Image(systemName: "globe")
                            .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2, width: 17)
                        Link(destination: URL(string: "https://samuelgin.github.io/Sentimizer-Website/")!) {
                            Text("Our Website")
                                .font(.sentiMedium(size: 17))
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "hand.raised.fill")
                            .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2, width: 17)
                        Link(destination: URL(string: "https://samuelgin.github.io/Sentimizer-Website/privacy.html")!) {
                            Text("Privacy Policy")
                                .font(.sentiMedium(size: 17))
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Button(action: {
                            crispPresented.toggle()
                        }){
                            Image(systemName: "envelope.fill")
                                .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2, width: 17)
                        }
                        .sheet(isPresented:  $crispPresented, content:{
                            CrispUIViewControllerRepresentable()
                        })
                        
                        Text("Feedback / Support")
                            .font(.sentiMedium(size: 17))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.forward")
                    }
                    
                    Text("""
                        1.1.1: This version of Sentimizer is still in beta. Some features may not be available yet.
                        Created by Samuel Ginsberg, Justin Hohenstein and Henry Pham. Smiley Icons made by Freepik from flaticon.com.
                        """)
                    .multilineTextAlignment(.leading)
                    .font(.sentiLight(size: 12))
                    .foregroundColor(.gray)
                } header: {
                    Text("Other")
                        .font(.sentiLight(size: 13))
                        .foregroundColor(.gray)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .font(.sentiBold(size: 20))
            .padding(.top, 5)
            .onAppear {
                //colorTheme = Settings.getColorTheme()
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
