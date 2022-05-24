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
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(K.brandColor2))
                        Text("Edit Activity Categories")
                            .minimumScaleFactor(0.8)
                    }
                }
            }
            
            Section(header: Text("Color Scheme").foregroundColor(.gray)) {
                Button {} label: {
                    HStack {
                        Image(systemName: "sun.max.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(K.brandColor4))
                        Text("Light")
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                HStack {
                    Image(systemName: "moon.stars")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(K.brandColor4))
                    Text("Dark")
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
                HStack {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(K.brandColor4))
                    Text("Auto")
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
        .listStyle(.insetGrouped)
        .font(.senti(size: 20))
        .padding(.top)
        .onAppear {
            UITableView.appearance().backgroundColor = .clear // tableview background
        }
        .foregroundColor(.black)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
