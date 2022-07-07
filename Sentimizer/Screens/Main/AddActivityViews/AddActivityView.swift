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
    
    @StateObject private var persistenceController = PersistenceController()
    
    @ObservedObject var keyboardHeightHelper = KeyboardHelper()
    @State private var textFieldYPlusHeight: CGFloat = 0
    
    @FetchRequest(entity: Activity.entity(), sortDescriptors: []) var activities: FetchedResults<Activity>
    
    @State private var description = ""
    @State private var feeling = ""
    @State private var activity = ""
    @State private var icon = ""
    @State private var date = Date()
    
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
                                    "Time",
                                    selection: $date,
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .frame(maxWidth: 270)
                                
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
                                
                                Group {
                                    Text("How are you?")
                                        .font(.senti(size: 25))
                                        .padding(.top, 30)
                                    
                                    MoodPicker(width: g.size.width, feeling: $feeling)
                                    
                                    Text("What's happening?")
                                        .font(.senti(size: 25))
                                        .padding(.top, 30)
                                    
                                    SentiTextEditor(text: $description)
                                }
                                .opacity(activity.isEmpty ? 0.5 : 1)
                                .disabled(activity.isEmpty)
                            }
                            .offset(y: keyboardHeightHelper.height != 0 ? (g.size.height - textFieldYPlusHeight - (g.size.height - keyboardHeightHelper.height) + 10) : 0)
                            .animation(.easeOut, value: keyboardHeightHelper.height)
                            
                            
                            Button {
                                persistenceController.saveActivity(activity: activity, icon: icon, description: description, feeling: feeling, date: date, viewContext)
                                
                                DispatchQueue.global(qos: .userInitiated).async {
                                    
                                    let monthInfluence = StatisticsData.getInfluence(viewContext: viewContext, interval: K.timeIntervals[2], activities: activities)
                                    
                                    persistenceController.saveInfluence(with: K.monthInfluence, for: monthInfluence)
                                    
                                    let yearInfluence = StatisticsData.getInfluence(viewContext: viewContext, interval: K.timeIntervals[3], activities: activities)
                                    
                                    persistenceController.saveInfluence(with: K.yearInfluence, for: yearInfluence)
                                }
                                
                                dismiss()
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
                            .opacity(feeling.isEmpty || activity.isEmpty ? 0.5 : 1)
                            .disabled(feeling.isEmpty || activity.isEmpty)
                            .animation(.easeIn, value: feeling.isEmpty)
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
            .onAppear {
                // for debugging
                // deleteAllData(moc: viewContext)
                // addSampleData(moc: viewContext)
            }
        }
    }
}

struct AddActivitySheet_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView()
    }
}
