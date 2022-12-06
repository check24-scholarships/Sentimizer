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
    @State private var userDuration: Int16 = 0
    
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
                        
                        ChangeActivityDuration(duration: $userDuration)
                        
                        ChangeActivityName(activity: $userActivity, icon: $userIcon)
                        
                        ChangeActivityMood(width: width, mood: $userMood, activity: activity)
                        
                        ChangeActivityDescription(description: $userDescription, isEditing: $isEditingDescription, activity: activity, scrollView: scrollView)
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
                    Spacer()
                    Button("Done") {
                        dismissKeyboard()
                        persistenceController.updateActivityDescription(with: userDescription, id: activity.id, viewContext)
                        withAnimation(.easeOut) {
                            isEditingDescription = false
                        }
                    }
                    .font(.senti(size: 19))
                    .fontWeight(.bold)
                    .foregroundColor(.brandColor2)
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
                userDuration = activity.duration
                print(userDuration)
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
        .onChange(of: userDuration) { newValue in
            persistenceController.updateActivityDuration(with: newValue, id: activity.id, viewContext)
        }
    }
}

//MARK: - ChangeActivityDate

struct ChangeActivityDate: View {
    @Binding var date: Date
    
    var body: some View {
        HStack {
            Text("DATE")
                .font(.senti(size: 12))
                .fontWeight(.bold)
            Spacer()
        }
        
        DatePicker(
            "",
            selection: $date,
            in: ...Date(),
            displayedComponents: [.date, .hourAndMinute]
        )
        .labelsHidden()
        .padding(.bottom)
    }
}

struct ChangeActivityDuration: View {
    
    @Binding var duration: Int16
    @State private var durationHours: String = ""
    @State private var durationMinutes: String = ""
    @State private var oldHourValue = ""
    @State private var oldMinuteValue = ""
    
    var body: some View {
        
        HStack {
            Text("DURATION")
                .font(.senti(size: 12))
                .fontWeight(.bold)
            Spacer()
        }
        
        HStack(spacing: 0) {
            TextField("-", text: $durationHours)
            .frame(maxWidth: 22)
            .padding(5)
            .background(Color.gray.adjust(brightness: 0.35))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .keyboardType(.numberPad)
            
            Text(":")
            
            TextField("-", text: $durationMinutes)
            .frame(maxWidth: 22)
            .padding(5)
            .background(Color.gray.adjust(brightness: 0.35))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .keyboardType(.numberPad)
            
            Text("h:min")
                .padding(.leading, 3)
            
            Spacer()
        }
        .onAppear {
            // Set variables to correct hours and minutes with correct formatting
            var hours = String(Int(duration/60))
            var minutes = String(duration%60)
            if hours.count == 1 {
                hours = "0\(hours)"
            }
            if minutes.count == 1 {
                minutes = "0\(minutes)"
            }
            durationHours = hours
            durationMinutes = minutes
        }
        .onChange(of: durationHours) { newValue in
            // Only change hour value if it meets the specifications
            if let intValue = Int16(newValue), intValue < 24 && intValue >= 0 {
                oldHourValue = durationHours
            } else if newValue == "" {
                oldHourValue = durationHours
            } else {
                durationHours = oldHourValue
            }
            updateDurationWithMinutesAndHours()
        }
        .onChange(of: durationMinutes) { newValue in
            if let intValue = Int16(newValue), intValue < 60 && intValue >= 0 {
                oldMinuteValue = durationMinutes
            } else if newValue == "" {
                oldMinuteValue = durationMinutes
            } else {
                durationMinutes = oldMinuteValue
            }
            updateDurationWithMinutesAndHours()
        }
        .padding(.bottom, 20)
        
    }
    
    func updateDurationWithMinutesAndHours() {
        duration = Int16((Int(durationMinutes) ?? 0) + (Int(durationHours) ?? 0)*60)
    }
}

struct ChangeActivityName: View {
    @Binding var activity: String
    @Binding var icon: String
    
    var body: some View {
        HStack {
            Text("ACTIVITY")
                .font(.senti(size: 12))
                .fontWeight(.bold)
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

//MARK: - ChangeActivityMood

struct ChangeActivityMood: View {
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
            .fontWeight(.bold)
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

//MARK: - ChangeActivityDescription

struct ChangeActivityDescription: View {
    
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
                    .fontWeight(.bold)
                    .padding(.top, 5)
                    .lineLimit(15)
                    .id(1)
                
                Group {
                    if isEditing {
                        SentiTextEditor(showToolbar: false, text: $description)
                            .onTapGesture {
                                withAnimation {
                                    scrollView.scrollTo(1, anchor: .top)
                                }
                            }
                    } else {
                        Text(description.isEmpty ? LocalizedStringKey("Describe your activity...") : LocalizedStringKey(description))
                            .font(.senti(size: 18))
                            .fontWeight(.bold)
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
        ActivityDetailView(activity: ActivityData(id: "", activity: "Walk", icon: "figure.walk", date: Date(), duration: 20000, description: "", sentiment: "happy"), day: "Today")
    }
}
