//
//  SentiTextEditor.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 14.05.22.
//

import SwiftUI

struct SentiTextEditor: View {
    
    var description: String = "Describe your activity and how you feel now..."
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(description)
                    .font(.senti(size: 15))
                    .opacity(0.5)
                    .padding(7)
            }

            TextEditor(text: $text)
                .frame(height: 150)
                .font(.senti(size: 15))
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                }
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
        .padding()
        .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.gray.opacity(0.3)))
    }
}

struct TextEditor_Previews: PreviewProvider {
    static var previews: some View {
        SentiTextEditor(text: .constant(""))
    }
}
