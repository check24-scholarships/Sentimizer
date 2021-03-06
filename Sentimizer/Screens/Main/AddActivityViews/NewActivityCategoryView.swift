//
//  NewActivityCategoryView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 10.05.22.
//

import SwiftUI

struct NewActivityCategoryView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject private var persistenceController = PersistenceController()
    
    @State private var activityTextFieldText = ""
    @State private var textFieldEditing = false
    
    @State private var iconName = ""
    
    @Environment(\.dismiss) private var dismiss
    @State private var shouldBeDismissed = false
    @State private var showingDoubleNameAlert = false
    
    var body: some View {
        ScrollView {
            VStack {
                ViewTitle("New activity category", fontSize: 30)
                
                SentiTextField(placeholder: "Activity category name", text: $activityTextFieldText, textFieldEditing: $textFieldEditing, done: .constant(false))
                
                NavigationLink {
                    ZStack {
                        Color.bgColor.ignoresSafeArea()
                        IconChooser(done: $shouldBeDismissed, iconName: $iconName)
                    }
                } label: {
                    SentiButton(icon: nil, title: "Next", fontSize: 15, chevron: false)
                        .frame(width: 150)
                }
                .disabled(activityTextFieldText.isEmpty)
                .disabled(persistenceController.activityCategoryNameAlreadyExists(for: activityTextFieldText, viewContext))
                .opacity(activityTextFieldText.isEmpty ? 0.3 : 1)
                .animation(.easeOut, value: activityTextFieldText)
                .padding(.top)
                .onTapGesture {
                    showingDoubleNameAlert = true
                }
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
            
            persistenceController.saveNewActivityCategory(name: activityTextFieldText, icon: iconName, viewContext)
        }
        .alert(isPresented: $showingDoubleNameAlert) {
            Alert(title: Text("Error"),
                  message: Text("This name already exists. Please choose another one."),
                  dismissButton: .default(Text("OK"), action: {
                activityTextFieldText = ""
            }))
        }
    }
}

struct NewActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NewActivityCategoryView()
    }
}
