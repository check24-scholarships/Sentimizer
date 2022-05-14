//
//  ActivityChooserView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, 2022.
//

import SwiftUI

struct ActivityChooserView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var activity: (String, String)
    
    var body: some View {
        ScrollView {
            VStack {
                ViewTitle("Choose your activity", fontSize: 30)
                    .frame(maxWidth: .infinity)
                
                ForEach(0 ..< K.defaultActivities.0.count, id: \.self) { i in
                    Button {
                        activity = (K.defaultActivities.1[i], K.defaultActivities.0[i])
                        dismiss()
                    } label: {
                        SentiButton(icon: K.defaultActivities.1[i], title: K.defaultActivities.0[i])
                    }
                }
                
                NavigationLink {
                    ZStack {
                        K.bgColor.ignoresSafeArea()
                        NewActivityView()
                    }
                } label: {
                    SentiButton(icon: "plus.circle", title: "Add new activity", style: .outlined, fontSize: 20, textColor: .gray)
                        .padding()
                        .padding(.top)
                }
            }
            .padding()
        }
    }
    
}

struct ActivityChooser_Previews: PreviewProvider {
    static var previews: some View {
        ActivityChooserView(activity: .constant(("", "")))
    }
}
