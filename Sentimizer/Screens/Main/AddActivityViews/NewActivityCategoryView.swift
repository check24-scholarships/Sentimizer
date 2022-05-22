//
//  NewActivityCategoryView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 10.05.22.
//

import SwiftUI

struct NewActivityCategoryView: View {
    @State private var activityTextFieldText = ""
    @State private var textFieldEditing = false
    
    @State private var iconName = ""
    
    @Environment(\.dismiss) private var dismiss
    @State private var shouldBeDismissed = false
    
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject private var dataController = DataController()
    
    var body: some View {
        ScrollView {
            VStack {
                ViewTitle("New activity category", fontSize: 30)
                
                SentiTextField(placeholder: "Activity category name", text: $activityTextFieldText, textFieldEditing: $textFieldEditing, done: .constant(false))
                
                NavigationLink {
                    ZStack {
                        K.bgColor.ignoresSafeArea()
                        IconChooser(done: $shouldBeDismissed, iconName: $iconName)
                    }
                } label: {
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
            }
            .simultaneousGesture(
                DragGesture().onChanged { value in
                    textFieldEditing = false
                }
            )
            .padding(.bottom)
        }
        .padding(.horizontal, 15)
        .onChange(of: shouldBeDismissed) { _ in
            dismiss()
            
            dataController.saveNewActivityCategory(name: activityTextFieldText, icon: iconName, viewContext)
        }
    }
}

struct NewActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NewActivityCategoryView()
    }
}
