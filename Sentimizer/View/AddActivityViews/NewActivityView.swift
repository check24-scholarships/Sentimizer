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
    
    var columns: [GridItem] =
    [.init(.adaptive(minimum: 35, maximum: 55))]
    @State var imageWidth: CGFloat = 35
    
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
                .padding(.vertical)
                .onTapGesture {
                    textFieldFocus = true
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
                ForEach(K.defaultIcons, id: \.0.self) { category in
                    Text(category.0)
                        .font(.senti(size: 23))
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(category.1, id: \.self) { icon in
                            Image(systemName: icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .overlay(
                                    GeometryReader { g in
                                        Color.clear
                                            .onAppear {
                                                imageWidth = g.size.width
                                            }
                                    }
                                )
                                .frame(height: imageWidth)
                                .padding(3)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).opacity(0.5).frame(width: imageWidth+10, height: imageWidth+10).gradientForeground())
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
        .padding(.horizontal, 15)
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
