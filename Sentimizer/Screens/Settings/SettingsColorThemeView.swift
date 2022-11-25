//
//  SettingsColorThemeView.swift
//  Sentimizer
//
//  Created by Henry Pham on 25.11.22.
//

import SwiftUI

struct SettingsColorThemeView: View {
    
    @State private var colorTheme = Settings.getColorTheme()
    
    @State private var colorScheme: K.AppColorScheme = Settings.getColorScheme()
    
    var body: some View {
        List {
            Section(header: Text("Color Scheme").font(.senti(size: 13)).foregroundColor(.gray)) {
                Button {
                    Settings.saveColorScheme(.light)
                    colorScheme = Settings.getColorScheme()
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
        }
        .onAppear {
            colorTheme = Settings.getColorTheme()
        }
        .padding(.horizontal, -5)
    }
}

struct SettingsColorThemeView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsColorThemeView()
    }
}
