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
                                .font(.senti(size: 17))
                                .fontWeight(.medium)
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
                                .font(.senti(size: 17))
                                .fontWeight(.medium)
                            Spacer()
                        }
                    }
                    NavigationLink {
                        ZStack {
                            Color.bgColor.ignoresSafeArea()
                            SettingsColorThemeView()
                                .padding(.top, -26)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "rays")
                                .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2)
                            Text("Theme")
                                .font(.senti(size: 17))
                            Spacer()
                        }
                    }
                } header: {
                    Text("General")
                        .font(.senti(size: 13))
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
                                .font(.senti(size: 17))
                            Spacer()
                            if(appHasToBeUnlocked) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                } header: {
                    Text("Privacy")
                        .font(.senti(size:13))
                        .foregroundColor(.gray)
                } footer: {
                    Text("Use Face ID / Touch ID to restrict access to Sentimizer.")
                        .font(.senti(size: 13))
                        .foregroundColor(.gray)
                }
                
                Section {
                    Link(destination: URL(string: "https://samuelgin.github.io/Sentimizer-Website/")!){
                        HStack{
                            Image(systemName: "globe")
                                .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2, width: 17)
                            Text("Our Website")
                                .font(.senti(size: 17))
                                .fontWeight(.medium)
                            Spacer()
                        }
                    }

                    Link(destination: URL(string: "https://samuelgin.github.io/Sentimizer-Website/privacy.html")!) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2, width: 17)
                            Text("Privacy Policy")
                                .font(.senti(size: 18))
                                .fontWeight(.medium)
                            Spacer()
                        }
                    }
                    
                        NavigationLink {
                            CrispUIViewControllerRepresentable()
                        } label: {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: .brandColor2, width: 17)
                                Text("Feedback / Support")
                                    .font(.senti(size: 18))
                                    .fontWeight(.medium)
                                
                                Spacer()
                            }
                        }
                    Text("""
                        1.1.1: This version of Sentimizer is still in beta. Some features may not be available yet.
                        Created by Samuel Ginsberg, Justin Hohenstein and Henry Pham. Smiley Icons made by Freepik from flaticon.com.
                        """)
                    .multilineTextAlignment(.leading)
                    .font(.senti(size: 12))
                    .foregroundColor(.gray)
                } header: {
                    Text("Other")
                        .font(.senti(size: 13))
                        .foregroundColor(.gray)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .font(.senti(size: 20))
            .fontWeight(.bold)
            .padding(.top, 5)
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
