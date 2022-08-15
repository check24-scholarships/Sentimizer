//
//  ActivityDetailView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 13.05.22.
//

import SwiftUI
import CoreData

struct ActivityDetailView: View {
    let activity: ActivityData
    let day: LocalizedStringKey
    
    @State private var userDescription = ""
    @State private var userMood = ""
    @State private var userActivity = ""
    @State private var userIcon = K.unspecifiedSymbol
    @State private var userDate = Date()
    
    @State private var alreadySet = false
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var model: Model
    
    @StateObject private var persistenceController = PersistenceController()
    
    @State private var width: CGFloat = 150
    
    @State private var isEditingDescription = false
    
    @FetchRequest(sortDescriptors: []) private var activities: FetchedResults<Activity>
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        ChangeActivityDate(date: $userDate)
                        
                        ActivityDetailActivity(activity: $userActivity, icon: $userIcon)
                        
                        ActivityDetailMood(width: width, mood: $userMood, activity: activity)
                        
                        ActivityDetailDescriptionEditor(description: $userDescription, isEditing: $isEditingDescription, activity: activity, scrollView: scrollView)
                    }
                    .overlay(
                        GeometryReader { g in
                            Color.clear
                                .onAppear {
                                    width = g.size.width
                                }
                        }
                    )
                    .padding()
                    .standardBackground()
                    .padding(.horizontal, 15)
                    .padding(.top)
                    
                    SentiDeleteButton(label: "Delete this activity") {
                        persistenceController.deleteActivity(id: activity.id, viewContext)
                        
                        model.updateInfluence(activities: activities, viewContext, persistenceController: persistenceController)
                        
                        dismiss()
                    }
                }
            }
            .navigationTitle(userActivity)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            dismissKeyboard()
                            persistenceController.updateActivityDescription(with: userDescription, id: activity.id, viewContext)
                            withAnimation(.easeOut) {
                                isEditingDescription = false
                            }
                        }
                        .font(.senti(size: 19))
                        .foregroundColor(.brandColor2)
                    }
                }
            }
        }
        .onAppear {
            if !alreadySet {
                userActivity = activity.activity
                userIcon = activity.icon
                userMood = activity.sentiment
                userDescription = activity.description
                userDate = activity.date
                alreadySet = true
            }
        }
        .onChange(of: userActivity) { newValue in
            persistenceController.updateActivity(with: userActivity, id: activity.id, viewContext)
            model.updateInfluence(activities: activities, viewContext, persistenceController: persistenceController)
        }
        .onChange(of: userDate) { newValue in
            persistenceController.updateActivityDate(with: newValue, id: activity.id, viewContext)
        }
    }
}

struct ChangeActivityDate: View {
    @Binding var date: Date
    
    var body: some View {
        HStack {
            Text("DATE")
                .font(.senti(size: 12))
            Spacer()
        }
        
        DatePicker(
            "",
            selection: $date,
            in: ...Date(),
            displayedComponents: [.date, .hourAndMinute]
        )
        .labelsHidden()
        .padding(.bottom, 20)
    }
}

struct ActivityDetailActivity: View {
    @Binding var activity: String
    @Binding var icon: String
    
    var body: some View {
        HStack {
            Text("ACTIVITY")
                .font(.senti(size: 12))
            Spacer()
        }
        
        NavigationLink {
            ActivityChooserView(activity: $activity, icon: $icon)
                .padding(.top, -30)
                .navigationBarTitleDisplayMode(.inline)
        } label: {
            SentiButton(icon: icon, title: LocalizedStringKey(activity), chevron: false)
                .scaleEffect(0.9)
                .padding(.top)
        }
        .padding(.bottom)
    }
}

struct ActivityDetailMood: View {
    let width: CGFloat
    @Binding var mood: String
    let activity: ActivityData
    
    @StateObject private var persistenceController = PersistenceController()
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(entity: Activity.entity(), sortDescriptors: []) private var activities: FetchedResults<Activity>
    
    @EnvironmentObject private var model: Model
    
    var body: some View {
        Text("MOOD")
            .font(.senti(size: 12))
            .padding(.top, 5)
        
        MoodPicker(width: width, opaque: true, feeling: $mood)
            .onChange(of: mood) { newValue in
                persistenceController.updateMood(with: newValue, id: activity.id, viewContext)
                mood = newValue
                model.updateInfluence(activities: activities, viewContext, persistenceController: persistenceController)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom)
    }
}

struct ActivityDetailDescriptionEditor: View {
    
    @Binding var description: String
    @Binding var isEditing: Bool
    let activity: ActivityData
    let scrollView: ScrollViewProxy
    
    @StateObject private var persistenceController = PersistenceController()
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("DESCRIPTION")
                    .font(.senti(size: 12))
                    .padding(.top, 5)
                    .lineLimit(15)
                    .id(1)
                
                Group {
                    if isEditing {
                        SentiTextEditor(text: $description)
                            .onTapGesture {
                                withAnimation {
                                    scrollView.scrollTo(1, anchor: .top)
                                }
                            }
                    } else {
                        Text(description.isEmpty ? LocalizedStringKey("Describe your activity...") : LocalizedStringKey(description))
                            .font(.senti(size: 18))
                            .padding(.bottom)
                            .opacity(description.isEmpty ? 0.5 : 1)
                    }
                }
                .padding(.top, 1)
            }
            Spacer()
            if isEditing {
                Button {
                    dismissKeyboard()
                    persistenceController.updateActivityDescription(with: description, id: activity.id, viewContext)
                    withAnimation(.easeOut) {
                        isEditing = false
                    }
                } label: {
                    Text("Done")
                        .bold()
                }
            } else {
                Button {
                    withAnimation(.easeOut) {
                        isEditing = true
                    }
                } label: {
                    Image(systemName: "pencil")
                        .standardIcon()
                        .frame(height: 20)
                        .padding(13)
                        .standardBackground()
                }
            }
        }
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews : some View {
        ActivityDetailView(activity: ActivityData(id: "", activity: "Walk", icon: "figure.walk", date: Date(), description: "", sentiment: "happy"), day: "Today")
    }
}
