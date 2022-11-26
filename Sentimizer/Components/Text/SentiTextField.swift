//
//  SentiTextField.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import SwiftUI

struct SentiTextField: View {
    let placeholder: LocalizedStringKey
    @Binding var text: String
    @Binding var textFieldEditing: Bool
    @Binding var done: Bool
    
    @FocusState var textFieldFocus: Bool
    
    @AppStorage(K.colorTheme) private var colorTheme = false
    
    @State private var brandColor1 = Color.brandColor1
    @State private var brandColor2 = Color.brandColor2
    
    var body: some View {
        TextField(placeholder, text: $text) { editing in
            textFieldEditing = editing
        }
        .padding()
        .background(Color.dayViewBgColor)
        .cornerRadius(25)
        .background(
            RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 3).foregroundColor(brandColor1))
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
                Spacer()
                Button("Done") {
                    dismissKeyboard()
                }
                .font(.senti(size: 19))
                .fontWeight(.semibold)
                .foregroundColor(brandColor2)
            }
        }
        .onAppear {
            brandColor1 = Color.brandColor1
            brandColor2 = Color.brandColor2
        }
        .onChange(of: colorTheme) { _ in
            brandColor1 = Color.brandColor1
            brandColor2 = Color.brandColor2
        }
    }
}

struct SentiTextField_Previews: PreviewProvider {
    static var previews: some View {
        SentiTextField(placeholder: "Activity", text: .constant(""), textFieldEditing: .constant(false), done: .constant(false))
    }
}
