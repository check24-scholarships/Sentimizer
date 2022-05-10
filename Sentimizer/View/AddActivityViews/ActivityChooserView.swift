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
    
    let testContent = (["Walking", "Training", "Gaming", "Project Work", "Lunch"], ["figure.walk", "sportscourt", "gamecontroller", "briefcase", "fork.knife"])
    
    var body: some View {
        ScrollView {
            VStack {
                ViewTitle("Choose your activity", fontSize: 30)
                    .frame(maxWidth: .infinity)
                
                ForEach(0 ..< testContent.0.count, id: \.self) { i in
                    Button {
                        activity = (testContent.1[i], testContent.0[i])
                        dismiss()
                    } label: {
                        SentiButton(icon: testContent.1[i], title: testContent.0[i])
                    }
                }
                
                NavigationLink { NewActivityView() } label: {
                    SentiButton(icon: "plus.circle", title: "Add new activity", style: .outlined, textColor: .gray, chevron: false, leading: true)
                        .padding()
                        .padding(.top)
                }
                
//                ZStack {
//                    
//                    }
                    
//                    Group {
//                        if !textFieldEditing && addTextFieldText.isEmpty {
//
//                        } else {
//                            SentiButton(icon: "plus.circle", title: "", style: .outlined, textColor: .gray, chevron: false, leading: true)
//                        }
//                    }
//                    .onTapGesture {
//                        textFieldFocus = true
//                    }
//                }
//                .padding()
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
