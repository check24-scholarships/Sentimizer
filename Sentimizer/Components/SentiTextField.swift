//
//  SentiTextField.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import SwiftUI

struct SentiTextField: View {
    let placeholder: String
    @Binding var text: String
    @Binding var textFieldEditing: Bool
    @Binding var done: Bool
    
    @FocusState var textFieldFocus: Bool
    
    var body: some View {
        TextField(placeholder, text: $text) { editing in
            textFieldEditing = editing
        }
        .padding()
        .background(K.dayViewBgColor)
        .cornerRadius(25)
        .background(
            RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 3).foregroundColor(K.brandColor1))
        .focused($textFieldFocus)
        .padding(.vertical)
        .padding(.horizontal, 2)
        .onTapGesture {
            textFieldFocus = true
        }
        .onChange(of: text, perform: { newValue in
            done = true
        })
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        dismissKeyboard()
                    }
                    .font(.senti(size: 19))
                    .foregroundColor(K.brandColor2)
                }
            }
        }
    }
}

struct SentiTextField_Previews: PreviewProvider {
    static var previews: some View {
        SentiTextField(placeholder: "Activity", text: .constant(""), textFieldEditing: .constant(false), done: .constant(false))
    }
}
