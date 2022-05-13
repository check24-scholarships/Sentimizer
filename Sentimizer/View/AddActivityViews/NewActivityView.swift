//
//  NewActivityView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 10.05.22.
//

import SwiftUI

struct NewActivityView: View {
    @State var activityTextFieldText = ""
    @State var textFieldEditing = false
    @FocusState var textFieldFocus: Bool
    
    @State var iconName = ""
    
    @Environment(\.dismiss) private var dismiss
    @State var shouldBeDismissed = false
    
    var body: some View {
        ScrollView {
            VStack {
                ViewTitle("New activity", fontSize: 30)
                
                TextField("Activity name", text: $activityTextFieldText) { editing in
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
                
                NavigationLink { IconChooser(done: $shouldBeDismissed, iconName: $iconName) } label: {
                    SentiButton(icon: nil, title: "Next", fontSize: 15, chevron: false)
                        .frame(width: 150)
                }
                .disabled(activityTextFieldText.isEmpty)
                .opacity(activityTextFieldText.isEmpty ? 0.3 : 1)
                .animation(.easeOut, value: activityTextFieldText)
                .padding(.top)
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
            .padding(.bottom)
        }
        .padding(.horizontal, 15)
        .onChange(of: shouldBeDismissed) { _ in
            saveNewActivity(for: activityTextFieldText, icon: iconName)
            dismiss()
        }
    }
    
    private func saveNewActivity(for activity: String, icon: String) {
        print(#function)
    }
}

struct IconChooser: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var done: Bool
    @Binding var iconName: String
    
    var columns: [GridItem] =
    [.init(.adaptive(minimum: 40, maximum: 55))]
    @State var imageBounds: CGSize = CGSize(width: 35, height: 35)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ViewTitle("Choose your icon", fontSize: 30)
                
                ForEach(K.defaultIcons, id: \.0.self) { category in
                    Text(category.0.uppercased())
                        .font(.senti(size: 12))
                        .padding(.top)
                    
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(category.1, id: \.self) { icon in
                            Group {
                                Image(systemName: icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(5)
                                    .overlay(
                                        GeometryReader { g in
                                            Color.clear
                                                .onAppear {
                                                    imageBounds = g.size
                                                }
                                        }
                                    )
                                    .frame(width: imageBounds.width > imageBounds.height ? imageBounds.width : imageBounds.height,
                                           height: imageBounds.width > imageBounds.height ? imageBounds.width : imageBounds.height)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .opacity(iconName == icon ? 0.5 : 0)
                                            .gradientForeground()
                                    )
                                    .onTapGesture {
                                        iconName = icon
                                    }
                            }
                        }
                    }
                }
                .padding(.horizontal, 2)
                
                Button {
                    dismiss()
                    done = true
                } label: {
                    SentiButton(icon: nil, title: "Done", fontSize: 15, chevron: false)
                        .frame(width: 150)
                }
                .padding(.top, 20)
                .frame(maxWidth: .infinity)
                .disabled(iconName.isEmpty)
                .opacity(iconName.isEmpty ? 0.3 : 1)
                .animation(.easeOut, value: iconName)
            }
            .padding(.horizontal, 15)
        }
    }
    
    struct IconBackground: View {
        let full: Bool
        
        var body: some View {
            if full {
                RoundedRectangle(cornerRadius: 10)
                    .opacity(0.5)
                    .gradientForeground()
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .opacity(0.5)
                    .gradientForeground()
            }
        }
    }
}

struct NewActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NewActivityView()
    }
}
