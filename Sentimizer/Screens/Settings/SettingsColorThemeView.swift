//
//  SettingsColorThemeView.swift
//  Sentimizer
//
//  Created by Henry Pham on 25.11.22.
//

import SwiftUI

struct SettingsColorThemeView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var colorTheme = Settings.getColorTheme()
    
    @State private var colorScheme: K.AppColorScheme = Settings.getColorScheme()
    
    var body: some View {
            VStack{
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
                                    .font(.senti(size: 17))
                                    .fontWeight(.medium)
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
                                    .font(.senti(size: 17))
                                    .fontWeight(.medium)
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
                                    .font(.senti(size: 17))
                                    .fontWeight(.medium)
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
                                Image(systemName: "square.fill")
                                    .standardSentiSettingsIcon(foregroundColor: Color("brandColor1"), backgroundColor: Color("brandColor1"))
                                Text("Purple")                     .font(.senti(size: 17))
                                    .fontWeight(.medium)
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
                                Image(systemName: "square.fill")
                                    .standardSentiSettingsIcon( foregroundColor: Color("brandColor2Light2"), backgroundColor: Color("brandColor2Light2"))
                                Text("Green")
                                    .font(.senti(size: 17))
                                    .fontWeight(.medium)
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
}

struct SettingsColorThemeView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsColorThemeView()
    }
}
