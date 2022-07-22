//
//  AddActivityView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 24.04.22.
//

import SwiftUI
import CoreData

struct AddActivityView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject private var model: Model
    
    @StateObject private var persistenceController = PersistenceController()
    
    @ObservedObject var keyboardHeightHelper = KeyboardHelper()
    @State private var textFieldYPlusHeight: CGFloat = 0
    
    @FetchRequest(entity: Activity.entity(), sortDescriptors: []) private var activities: FetchedResults<Activity>
    
    @State private var description = ""
    @State private var mood = ""
    @State private var activity = ""
    @State private var icon = ""
    @State private var date = Date()
    
    let haptic = UINotificationFeedbackGenerator()
    
    var body: some View {
        GeometryReader { g in
            NavigationView {
                ZStack(alignment: .topLeading) {
                    ScrollView {
                        VStack {
                            Group {
                                ViewTitle("Add Activity")
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 25)
                                
                                DatePicker(
                                    "",
                                    selection: $date,
                                    in: ...Date(),
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .labelsHidden()
                                
                                ChooseCategory(activity: $activity, icon: $icon)
                                
                                Group {
                                    PickMood(mood: $mood, viewWidth: g.size.width)
                                    
                                    AddDescription(description: $description)
                                }
                                .opacity(activity.isEmpty ? 0.5 : 1)
                                .disabled(activity.isEmpty)
                            }
                            .offset(y: keyboardHeightHelper.height != 0 ? (g.size.height - textFieldYPlusHeight - (g.size.height - keyboardHeightHelper.height) + 10) : 0)
                            .animation(.easeOut, value: keyboardHeightHelper.height)
                            
                            
                            // Save Activity
                            Button {
                                persistenceController.saveActivity(activity: activity, icon: icon, description: description, feeling: mood, date: date, viewContext)
                                
                                model.updateInfluence(activities: activities, viewContext, persistenceController: persistenceController)
                                
                                dismiss()
                                
                                haptic.notificationOccurred(.success)
                            } label: {
                                SentiButton(icon: nil, title: "Save", chevron: false)
                                    .lineLimit(1)
                                    .frame(width: 250)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 30)
                                    .padding(.bottom, 30)
                            }
                            .overlay {
                                GeometryReader { g in
                                    Color.clear
                                        .onAppear {
                                            textFieldYPlusHeight = g.frame(in: CoordinateSpace.global).origin.y
                                        }
                                        .onChange(of: g.frame(in: CoordinateSpace.global).origin.y) { newValue in
                                            textFieldYPlusHeight = newValue
                                        }
                                }
                            }
                            .opacity(mood.isEmpty || activity.isEmpty ? 0.5 : 1)
                            .disabled(mood.isEmpty || activity.isEmpty)
                            .animation(.easeIn, value: mood.isEmpty)
                        }
                        .foregroundColor(.textColor)
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            dismissKeyboard()
                        }
                        .simultaneousGesture(
                            DragGesture().onChanged { value in
                                dismissKeyboard()
                            }
                        )
                    }
                    .navigationBarHidden(true)
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding([.leading, .top])
                }
            }
            .accentColor(.brandColor2)
        }
    }
    
    init() {
        let f: NSFetchRequest<Activity> = Activity.fetchRequest()
        f.sortDescriptors = []
        _activities = FetchRequest(fetchRequest: f)
    }
}

struct ChooseCategory: View {
    @Binding var activity: String
    @Binding var icon: String
    
    var body: some View {
        NavigationLink {
            ActivityChooserView(activity: $activity, icon: $icon)
                .padding(.top, -30)
                .navigationBarTitleDisplayMode(.inline)
        } label: {
            if activity.isEmpty {
                SentiButton(icon: nil, title: "Choose Activity Category", style: .outlined, fontSize: 20, textColor: .gray)
            } else {
                SentiButton(icon: icon, title: LocalizedStringKey(activity), chevron: false)
            }
        }
        .padding(.top, 40)
    }
}

struct PickMood: View {
    @Binding var mood: String
    let viewWidth: CGFloat
    
    var body: some View {
        Text("How are you?")
            .font(.senti(size: 25))
            .padding(.top, 30)
        
        MoodPicker(width: viewWidth, feeling: $mood)
    }
}

struct AddDescription: View {
    @Binding var description: String
    
    var body: some View {
        Text("What's happening?")
            .font(.senti(size: 25))
            .padding(.top, 30)
        
        SentiTextEditor(text: $description)
    }
}

struct AddActivitySheet_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView()
    }
}
