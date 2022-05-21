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
    @State private var userActivity = ("", "")
    
    @State private var width: CGFloat = 150
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var dataController = DataController()
    
    @State private var isEditingDescription = false
    @State private var isPresentingConfirm = false
    
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
                            ActivityChooserView(activity: $userActivity)
                                .padding(.top, -30)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            SentiButton(icon: userActivity.0, title: userActivity.1, chevron: false)
                                .scaleEffect(0.9)
                                .padding(.top)
                        }
                        .padding(.bottom)
                        
                        Text("MOOD")
                            .font(.senti(size: 12))
                            .padding(.top, 5)
                        
                        MoodPicker(width: width, opaque: true, feeling: $userMood)
                            .onChange(of: userMood) { newValue in
                                updateMood(with: newValue)
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
                                    updateActivityDescription(with: userDescription, id: id)
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
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
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
                    
                    Button {
                        isPresentingConfirm = true
                    } label: {
                        Text("Delete this activity")
                            .font(.senti(size: 20))
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 25).foregroundColor(K.brandColor1).opacity(0.1))
                            .padding()
                            .padding(.top)
                    }
                }
            }
            .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                Button("Delete activity", role: .destructive) {
                    dataController.deleteActivity(viewContext: viewContext, id: id)
                    dismiss()
                }
            } message: {
                Text("You cannot undo this action.")
            }
            .navigationTitle(day)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            dismissKeyboard()
                            updateActivityDescription(with: userDescription, id:id)
                            withAnimation(.easeOut) {
                                isEditingDescription = false
                            }
                        }
                        .font(.senti(size: 19))
                        .foregroundColor(K.brandColor2)
                    }
                }
            }
        }
        .onAppear {
            userActivity = (icon, activity)
            userMood = sentiment
            userDescription = description
            
        }
        .onChange(of: userActivity.1) { newValue in
            updateActivity(with: userActivity)
        }
    }
    
    func updateMood(with mood: String) {
        let objectID = viewContext.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: URL(string: id)!)!
        
        let object = try! viewContext.existingObject(with: objectID)
        
        (object as! Entry).feeling = mood
        sentiment = mood
        userMood = mood
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), update mood failed:")
            print(error.localizedDescription)
        }
    }
    
    func updateActivity(with activity: (String, String)) {
        let objectID = viewContext.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: URL(string: id)!)!
        
        let object = try! viewContext.existingObject(with: objectID)
        
        (object as! Entry).activity = activity.1
        self.activity = activity.1
        icon = activity.0
        userActivity = activity
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), update activity failed:")
            print(error.localizedDescription)
        }
    }
    
    func updateActivityDescription(with description: String, id: String) {
        let objectID = viewContext.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: URL(string: id)!)!
        
        let object = try! viewContext.existingObject(with: objectID)
        
        (object as! Entry).text = description
        self.description = description
        userDescription = description
        
        do {
            try viewContext.save()
        } catch {
            print("In \(#function), line \(#line), save activity failed:")
            print(error.localizedDescription)
        }
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews : some View {
        ActivityDetailView(activity: "Walking", icon: "figure.walk", description: "", day: "Today", time: "08:15", duration: "10 min", sentiment: "happy", id: "")
    }
}
