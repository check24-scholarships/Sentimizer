//
//  ActivityDetailView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 13.05.22.
//

import SwiftUI
import CoreData

struct ActivityDetailView: View {
    let activity: String
    let icon: String
    let description: String
    let day: LocalizedStringKey
    let time: String
    let duration: String
    let sentiment: String
    let id: String
    
    @State private var userDescription = ""
    @State private var userMood = ""
    @State private var userActivity = ""
    @State private var userIcon = K.unspecifiedSymbol
    
    @State private var alreadySet = false
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var model: Model
    
    @StateObject private var persistenceController = PersistenceController()
    
    @State private var width: CGFloat = 150
    
    @State private var isEditingDescription = false
    
    @FetchRequest(entity: Activity.entity(), sortDescriptors: []) private var activities: FetchedResults<Activity>
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                VStack(alignment: .leading) {
                    Text(time)
                        .font(.senti(size: 23))
                        .padding(.leading, 25)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("ACTIVITY")
                                .font(.senti(size: 12))
                            Spacer()
                        }
                        
                        NavigationLink {
                            ActivityChooserView(activity: $userActivity, icon: $userIcon)
                                .padding(.top, -30)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            SentiButton(icon: userIcon, title: LocalizedStringKey(userActivity), chevron: false)
                                .scaleEffect(0.9)
                                .padding(.top)
                        }
                        .padding(.bottom)
                        
                        Text("MOOD")
                            .font(.senti(size: 12))
                            .padding(.top, 5)
                        
                        MoodPicker(width: width, opaque: true, feeling: $userMood)
                            .onChange(of: userMood) { newValue in
                                persistenceController.updateMood(with: newValue, id: id, viewContext)
                                userMood = newValue
                                updateInfluence()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.bottom)
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("DESCRIPTION")
                                    .font(.senti(size: 12))
                                    .padding(.top, 5)
                                    .lineLimit(15)
                                    .id(1)
                                
                                Group {
                                    if isEditingDescription {
                                        SentiTextEditor(text: $userDescription)
                                            .onTapGesture {
                                                withAnimation {
                                                    scrollView.scrollTo(1, anchor: .top)
                                                }
                                            }
                                    } else {
                                        Text(userDescription.isEmpty ? LocalizedStringKey("Describe your activity...") : LocalizedStringKey(userDescription))
                                            .font(.senti(size: 18))
                                            .padding(.bottom)
                                            .opacity(userDescription.isEmpty ? 0.5 : 1)
                                    }
                                }
                                .padding(.top, 1)
                            }
                            Spacer()
                            if isEditingDescription {
                                Button {
                                    dismissKeyboard()
                                    persistenceController.updateActivityDescription(with: userDescription, id: id, viewContext)
                                    withAnimation(.easeOut) {
                                        isEditingDescription = false
                                    }
                                } label: {
                                    Text("Done")
                                        .bold()
                                }
                            } else {
                                Button {
                                    withAnimation(.easeOut) {
                                        isEditingDescription = true
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
                    
                    SentiDeleteButton(label: "Delete this activity") {
                        persistenceController.deleteActivity(id: id, viewContext)
                        
                        updateInfluence()
                        
                        dismiss()
                    }
                }
            }
            .navigationTitle(day)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            dismissKeyboard()
                            persistenceController.updateActivityDescription(with: userDescription, id: id, viewContext)
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
                userActivity = activity
                userIcon = icon
                userMood = sentiment
                userDescription = description
                alreadySet = true
            }
        }
        .onChange(of: userActivity) { newValue in
            persistenceController.updateActivity(with: userActivity, id: id, viewContext)
            updateInfluence()
        }
    }
    
    func updateInfluence() {
        DispatchQueue.global(qos: .userInitiated).async {
            let monthInfluence = StatisticsData.getInfluence(viewContext: viewContext, interval: K.timeIntervals[2], activities: activities)
            let yearInfluence = StatisticsData.getInfluence(viewContext: viewContext, interval: K.timeIntervals[3], activities: activities)
            DispatchQueue.main.async {
                model.influenceImprovedMonth = monthInfluence.0
                model.influenceWorsenedMonth = monthInfluence.1
                persistenceController.saveInfluence(with: K.monthInfluence, data: monthInfluence)
                
                model.influenceImprovedYear = yearInfluence.0
                model.influenceWorsenedYear = yearInfluence.1
                persistenceController.saveInfluence(with: K.yearInfluence, data: yearInfluence)
            }
        }
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews : some View {
        ActivityDetailView(activity: "Walking", icon: "figure.walk", description: "", day: "Today", time: "08:15", duration: "10 min", sentiment: "happy", id: "")
    }
}
