//
//  ActivityChooser.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 25.04.22.
//

import SwiftUI

struct ActivityChooser: View {
    @Binding var activity: (String, String)
    
    @Environment(\.dismiss) private var dismiss
    
    let testContent = (["Walking", "Training", "Gaming", "Project Work", "Lunch"], ["figure.walk", "sportscourt", "gamecontroller", "briefcase", "fork.knife"])
    
    var body: some View {
        ScrollView {
            VStack {
                ViewTitle("Choose Your Activity", fontSize: 30)
                    .frame(maxWidth: .infinity)
                
                ForEach(0 ..< testContent.0.count, id: \.self) { i in
                    Button {
                        activity = (testContent.1[i], testContent.0[i])
                        dismiss()
                    } label: {
                        SentiButton(icon: testContent.1[i], title: testContent.0[i])
                    }
                }
            }
            .padding()
        }
    }
}

struct ActivityChooser_Previews: PreviewProvider {
    static var previews: some View {
        ActivityChooser(activity: .constant(("", "")))
    }
}
