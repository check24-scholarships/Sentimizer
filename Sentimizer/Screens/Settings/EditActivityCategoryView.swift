//
//  EditActivityCategoryView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 17.05.22.
//

import SwiftUI
import CoreData

struct EditActivityCategoryView: View {
    @State var activityName: String
    @State var icon: String
    
    @State private var userActivityName = ""
    @State private var userIcon = ""
    @State private var textFieldEditing = false
    @State private var userEditingDone = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var viewContext
    @StateObject private var persistenceController = PersistenceController()
    
    @State private var iconChosen = false
    
    var body: some View {
        ScrollView {
            VStack {
                NavigationLink {
                    IconChooser(done: $iconChosen, iconName: $userIcon)
                } label: {
                    Image(systemName: userIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 50, maxHeight: 50)
                }
                .foregroundColor(.brandColor2)
                .padding()
                .standardBackground()
                .padding()
                .onChange(of: userIcon) { newValue in
                    persistenceController.updateActivityCategoryIcon(with: newValue, activityName: userActivityName, viewContext)
                    icon = newValue
                    activityName = userActivityName
                }
                
                SentiTextField(placeholder: "Activity category name", text: $userActivityName, textFieldEditing: $textFieldEditing, done: $userEditingDone)
                
                SentiDeleteButton(label: "Delete activity category") {
                    persistenceController.deleteActivityCategory(with: activityName, viewContext)
                    dismiss()
                }
                
                Button {
                    dismiss()
                } label: {
                    SentiButton(icon: nil, title: "Done", fontSize: 15, chevron: false)
                        .frame(width: 150)
                }
                .padding(.top, 20)
                .frame(maxWidth: .infinity)
                .disabled(userIcon.isEmpty || userActivityName.isEmpty)
                .opacity(userIcon.isEmpty || userActivityName.isEmpty ? 0.3 : 1)
                .animation(.easeOut, value: userIcon)
                .animation(.easeOut, value: userActivityName)
            }
            .padding(.horizontal, 12)
            .onTapGesture {
                textFieldEditing = false
            }
            .simultaneousGesture(
                DragGesture().onChanged { value in
                    textFieldEditing = false
                }
            )
        }
        .navigationTitle("Edit activity")
        .onAppear {
            userActivityName = activityName
            userIcon = icon
        }
        .onChange(of: userEditingDone) { _ in
            persistenceController.updateActivityCategoryName(with: userActivityName, oldName: activityName, viewContext)
            activityName = userActivityName
        }
    }
}

struct EditActivityView_Previews: PreviewProvider {
    static var previews: some View {
        EditActivityCategoryView(activityName: "Walking", icon: "figure.walk")
    }
}
