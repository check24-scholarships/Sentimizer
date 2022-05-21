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
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var iconChosen = false
    @State private var textFieldEditing = false
    @FocusState var textFieldFocus: Bool
    
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
                .foregroundColor(K.brandColor2)
                .padding()
                .standardBackground()
                .padding()
                .onChange(of: userIcon) { newValue in
                    updateActivityIcon(with: newValue, activityName: userActivityName)
                    icon = newValue
                    activityName = userActivityName
                }
                
                TextField("Activity name", text: $userActivityName) { editing in
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
                .onChange(of: userActivityName, perform: { newValue in
                    updateActivityName(with: newValue, oldName: activityName)
                    activityName = userActivityName
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
        }
        .navigationTitle("Edit activity")
        .onAppear {
            userActivityName = activityName
            userIcon = icon
        }
    }
    
    func updateActivityName(with activityName: String, oldName: String) {
        let fetchRequest: NSFetchRequest<Activity>
        fetchRequest = Activity.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        
        let activities = try! viewContext.fetch(fetchRequest)
        
        for activity in activities {
            if activity.name == oldName {
                activity.name = activityName
            }
        }
        
        try! viewContext.save()
    }
    
    func updateActivityIcon(with icon: String, activityName: String) {
        let fetchRequest: NSFetchRequest<Activity>
        fetchRequest = Activity.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        
        let activities = try! viewContext.fetch(fetchRequest)
        
        for activity in activities {
            if activity.name == activityName {
                activity.icon = icon
            }
        }
        
        try! viewContext.save()
    }
}

struct EditActivityView_Previews: PreviewProvider {
    static var previews: some View {
        EditActivityCategoryView(activityName: "Walking", icon: "figure.walk")
    }
}
