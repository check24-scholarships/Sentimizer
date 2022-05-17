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
    
    @StateObject private var dataController = DataController()
    
    @ObservedObject var keyboardHeightHelper = KeyboardHelper()
    @State private var textFieldYPlusHeight: CGFloat = 0
    
    @State private var description = ""
    @State private var feeling = ""
    @State private var activity = ("", "")
    
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
                                
                                NavigationLink {
                                    ActivityChooserView(activity: $activity)
                                        .padding(.top, -30)
                                        .navigationBarTitleDisplayMode(.inline)
                                } label: {
                                    if activity.1.isEmpty {
                                        SentiButton(icon: nil, title: "Choose Activity", style: .outlined, fontSize: 20, textColor: .gray)
                                    } else {
                                        SentiButton(icon: activity.0, title: activity.1, chevron: false)
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
                                .opacity(activity.1.isEmpty ? 0.5 : 1)
                                .disabled(activity.1.isEmpty)
                            }
                            .offset(y: keyboardHeightHelper.height != 0 ? (g.size.height - textFieldYPlusHeight - (g.size.height - keyboardHeightHelper.height) + 10) : 0)
                            .animation(.easeOut, value: keyboardHeightHelper.height)
                            
                            
                            Button {
                                dataController.saveActivity(activity: activity.1, icon: activity.0, description: description, feeling: feeling, date: Date(), viewContext: viewContext)
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
                            .opacity(feeling.isEmpty || activity.1.isEmpty ? 0.5 : 1)
                            .disabled(feeling.isEmpty || activity.1.isEmpty)
                            .animation(.easeIn, value: feeling.isEmpty)
                        }
                        .foregroundColor(K.textColor)
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
            .accentColor(K.brandColor2)
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
