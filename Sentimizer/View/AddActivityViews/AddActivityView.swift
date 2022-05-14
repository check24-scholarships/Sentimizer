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
    
    @ObservedObject var keyboardHeightHelper = KeyboardHelper()
    @State var textFieldYPlusHeight: CGFloat = 0
    
    @State var description = ""
    @State var feeling = ""
    @State var activity = ("", "")
    
    var body: some View {
        GeometryReader { g in
            NavigationView {
                ZStack(alignment: .topLeading) {
                    K.bgColor.ignoresSafeArea()
                    ScrollView {
                        VStack {
                            Group {
                                ViewTitle("Add Activity")
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 25)
                                
                                NavigationLink {
                                    ZStack {
                                        
                                        ActivityChooserView(activity: $activity)
                                            .padding(.top, -30)
                                        .navigationBarTitleDisplayMode(.inline)
                                    }
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
                                    
                                    MoodChooser(g: g, feeling: $feeling)
                                    
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
                            
                            GeometryReader { g2 in
                                Button {
                                    DataController.saveActivity(activity: activity.1, icon: activity.0, description: description, feeling: feeling, date: Date(), viewContext: viewContext)
                                    
                                    dismiss()
                                } label: {
                                    SentiButton(icon: nil, title: "Save", chevron: false)
                                        .lineLimit(1)
                                        .frame(width: 250)
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 30)
                                        .padding(.bottom)
                                }
                                .onAppear {
                                    textFieldYPlusHeight = g2.frame(in: CoordinateSpace.global).origin.y
                                }
                                .onChange(of: g2.frame(in: CoordinateSpace.global).origin.y) { newValue in
                                    textFieldYPlusHeight = newValue
                                }
                                .opacity(feeling.isEmpty || activity.1.isEmpty ? 0.5 : 1)
                                .disabled(feeling.isEmpty || activity.1.isEmpty)
                                .animation(.easeIn, value: feeling.isEmpty)
                            }
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

//MARK: - MoodChoser View
struct MoodChooser: View {
    let g: GeometryProxy
    
    @Binding var feeling: String
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                feeling = K.sentimentsArray[0]
            } label: {
                Image(K.sentimentsArray[0])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: g.size.width/5 - 30)
                    .padding(10)
                    .padding(.leading, 7)
                    .background(feeling == K.sentimentsArray[0] ? Rectangle().foregroundColor(K.sentimentColors[0].opacity(0.3)).frame(height: 100) : nil)
            }
            ForEach(1..<K.sentimentsArray.count, id: \.self) { index in
                HStack(spacing: 0) {
                    Divider()
                        .frame(height: g.size.width/5 - 30)
                    Button {
                        feeling = K.sentimentsArray[index]
                    } label: {
                        Image(K.sentimentsArray[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: g.size.width/5 - 30)
                            .padding(10)
                            .padding(.trailing, index == K.sentimentsArray.count-1 ? 7 : 0)
                            .background(feeling == K.sentimentsArray[index] ? Rectangle().foregroundColor(K.sentimentColors[index].opacity(0.2)).frame(height: 100) : nil)
                    }
                }
            }
        }
        .padding(.vertical, 7)
        .background(RoundedRectangle(cornerRadius: 25)
            .gradientForeground(.leading, .trailing)
            .shadow(radius: 10))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct AddActivitySheet_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView()
    }
}
