//
//  SettingsView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 17.05.22.
//

import SwiftUI

struct SettingsView: View {
    @State private var colorScheme: K.AppColorScheme = Settings.getColorScheme()
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    ActivityChooserView(activity: .constant(""), icon: .constant(""), redirectToEdit: true)
                        .padding(.top, -30)
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    HStack {
                        Image(systemName: "person.crop.rectangle.stack")
                            .standardSentiSettingsIcon(foregroundColor: .white, backgroundColor: K.brandColor2)
                        Text("Edit Activity Categories")
                            .minimumScaleFactor(0.8)
                    }
                }
            }
            
            Section(header: Text("Color Scheme").foregroundColor(.gray)) {
                Button {
                    Settings.saveColorScheme(.light)
                    colorScheme = Settings.getColorScheme()
                } label: {
                    HStack {
                        Image(systemName: "sun.max.fill")
                            .standardSentiSettingsIcon(foregroundColor: .gray, backgroundColor: K.brandColor4)
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
                            .standardSentiSettingsIcon(foregroundColor: .gray, backgroundColor: K.brandColor4)
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
                            .standardSentiSettingsIcon(foregroundColor: .gray, backgroundColor: K.brandColor4)
                        Text("Auto")
                        Spacer()
                        if(colorScheme == .auto) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .font(.senti(size: 20))
        .padding(.top, 5)
        .onAppear {
            UITableView.appearance().backgroundColor = .clear // tableview background
        }
        .foregroundColor(K.textColor)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
