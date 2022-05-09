//
//  ActivityChooser.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 25.04.22.
//

import SwiftUI

struct ActivityChooser: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var activity: (String, String)
    
    @State var addTextFieldText = ""
    @State var textFieldEditing = false
    @FocusState var textFieldFocus: Bool
    
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
                ZStack {
                    TextField("", text: $addTextFieldText) { editing in
                        textFieldEditing = editing
                        if editing == false && !addTextFieldText.isEmpty {
                            saveNewActivity(for: addTextFieldText)
                        }
                    }
                    .focused($textFieldFocus)
                    .padding()
                    .padding(.leading, 50)
                    Group {
                        if !textFieldEditing && addTextFieldText.isEmpty {
                            SentiButton(icon: "plus.circle", title: "Add", style: .outlined, textColor: .gray, chevron: false, leading: true)
                        } else {
                            SentiButton(icon: "plus.circle", title: "", style: .outlined, textColor: .gray, chevron: false, leading: true)
                        }
                    }
                    .onTapGesture {
                        textFieldFocus = true
                    }
                }
                .padding()
            }
            .padding()
        }
        .onTapGesture {
            textFieldEditing = false
            textFieldFocus = false
        }
        .simultaneousGesture(
            DragGesture().onChanged { value in
                textFieldEditing = false
                textFieldFocus = false
            }
        )
    }
    
    private func saveNewActivity(for activity: String) {
        print(#function)
    }
}

struct ActivityChooser_Previews: PreviewProvider {
    static var previews: some View {
        ActivityChooser(activity: .constant(("", "")))
    }
}
