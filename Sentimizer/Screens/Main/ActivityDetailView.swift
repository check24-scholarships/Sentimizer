//
//  ActivityDetailView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 13.05.22.
//

import SwiftUI
import CoreData

struct ActivityDetailView: View {
    @State var activity: String
    @State var icon: String
    @State var description: String
    @State var day: String
    @State var time: String
    @State var duration: String
    @State var sentiment: String
    @State var id: String
    
    @State private var userDescription = ""
    @State private var userMood = ""
    @State private var userActivity = ""
    @State private var userIcon = ""
    
    @State private var width: CGFloat = 150
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var persistenceController = PersistenceController()
    
    @State private var isEditingDescription = false
    
    @FetchRequest(entity: Activity.entity(), sortDescriptors: []) var activities: FetchedResults<Activity>
    
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
                            SentiButton(icon: userIcon, title: userActivity, chevron: false)
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
                                sentiment = newValue
                                userMood = newValue
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
                                        Text(userDescription.isEmpty ? "Describe your activity..." : userDescription)
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
                                    description = userDescription
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
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            print("This is run on a background queue")
                            let monthInfluence = StatisticsData.getInfluence(viewContext: viewContext, interval: K.timeIntervals[2], activities: activities)
                            
                            
                            persistenceController.saveInfluence(with: K.monthInfluence, for: monthInfluence)
                            
                            let yearInfluence = StatisticsData.getInfluence(viewContext: viewContext, interval: K.timeIntervals[3], activities: activities)
                            
                            persistenceController.saveInfluence(with: K.yearInfluence, for: yearInfluence)

                            DispatchQueue.main.async {
                                print("This is run on the main queue, after the previous code in outer block")
                            }
                        }
                        
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
                            description = userDescription
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
            userActivity = activity
            userIcon = icon
            userMood = sentiment
            userDescription = description
            
        }
        .onChange(of: userActivity) { newValue in
            persistenceController.updateActivity(with: userActivity, id: id, viewContext)
            activity = userActivity
            icon = userIcon
        }
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews : some View {
        ActivityDetailView(activity: "Walking", icon: "figure.walk", description: "", day: "Today", time: "08:15", duration: "10 min", sentiment: "happy", id: "")
    }
}
