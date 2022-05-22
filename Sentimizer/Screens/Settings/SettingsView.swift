//
//  SettingsView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 17.05.22.
//

import SwiftUI

struct SettingsView: View {
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
                        Text("Activities")
                    }
                }
                .listRowBackground(K.brandColor2Light)
            }
            
            Section {
                NavigationLink {
                    ActivityChooserView(activity: .constant(""), icon: .constant(""))
                        .padding(.top, -30)
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    HStack {
                        Image(systemName: "rays")
                        Text("Appearance")
                    }
                }
            }
            .listRowBackground(K.brandColor2Light)
        }
        .padding(.top)
        .background(K.bgColor)
        .onAppear {
            UITableView.appearance().backgroundColor = .clear // tableview background
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
