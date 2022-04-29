//
//  ActivityChooser.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 25.04.22.
//

import SwiftUI

struct ActivityChooser: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let testContent = (["Walking", "Training", "Gaming", "Project Work", "Lunch"], ["figure.walk", "sportscourt", "gamecontroller", "briefcase", "fork.knife"])
    
    var body: some View {
        ScrollView {
            VStack {
                ViewTitle("Choose Your Activity")
                    .frame(maxWidth: .infinity)
                
                let testCount = [0, 1, 2, 3, 4]
                ForEach(testCount, id: \.self) { i in
                    Button {
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
        ActivityChooser()
    }
}
