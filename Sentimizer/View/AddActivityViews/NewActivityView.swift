//
//  NewActivityView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 10.05.22.
//

import SwiftUI

struct NewActivityView: View {
    @State var addTextFieldText = ""
    @State var textFieldEditing = false
    @FocusState var textFieldFocus: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                ViewTitle("New activity", fontSize: 30)
                
                TextField("Activity name", text: $addTextFieldText) { editing in
                    textFieldEditing = editing
                    if editing == false && !addTextFieldText.isEmpty {
                        saveNewActivity(for: addTextFieldText)
                    }
                }
                .padding()
                .background(K.dayViewBgColor)
                .cornerRadius(25)
                .background(
                    RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 3).foregroundColor(K.brandColor1))
                .focused($textFieldFocus)
                .padding()
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
    }
    
    private func saveNewActivity(for activity: String) {
        print(#function)
    }
}

struct NewActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NewActivityView()
    }
}
