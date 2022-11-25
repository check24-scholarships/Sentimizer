//
//  SentiTextField.swift
//  Sentimizer
//
//
// Created by Henry on 23.11.2022

import SwiftUI

struct SentiWelcomeTextField: View {
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
        .focused($textFieldFocus)
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
                    .font(.sentiBold(size: 19))
                    .foregroundColor(brandColor2)
                }
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

struct SentiWelcomeTextField_Previews: PreviewProvider {
    static var previews: some View {
        SentiWelcomeTextField(placeholder: "Activity", text: .constant(""), textFieldEditing: .constant(false), done: .constant(false))
    }
}

