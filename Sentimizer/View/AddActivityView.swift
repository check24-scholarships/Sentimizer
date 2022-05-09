//
//  AddActivityView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 24.04.22.
//

import SwiftUI
import CoreData

// adds sample entries

func addSampleData(moc: NSManagedObjectContext) {
    let feelings = ["crying", "sad", "neutral", "content", "happy"]
    let activities = ["Walking", "Training", "Gaming", "Project Work", "Lunch"]
    
    for i in 0..<12 {
        for j in 0..<3 {
            let entry = Entry(context: moc)
            entry.text = "very important activity"
            entry.date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 60 * 60 * 24 * 32 * (Double(i) + Double(j) * 0.3))
            if i < feelings.count {
                entry.feeling = feelings[i]
                entry.activity = activities[i]
            } else {
                entry.feeling = "neutral"
                entry.activity = "Project Work"
            }
        }
    }
    
    do {
        try moc.save()
    } catch {
        print("In \(#function), line \(#line), save activity failed:")
        print(error.localizedDescription)
    }
}

struct AddActivityView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var viewContext
    
    @State var keyboardHeight: CGFloat = 0
    @State var textFieldYPlusHeight: CGFloat = 0
    
    @State var description = ""
    @State var feeling = ""
    @State var activity = ("", "")
    
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
                                    ActivityChooser(activity: $activity)
                                        .offset(y: -20) // !!! (swiftUI bug?)
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
                                    
                                    
                                    Text("What's happening?")
                                        .font(.senti(size: 25))
                                        .padding(.top, 30)
                                    
                                    ZStack(alignment: .topLeading) {
                                        if description.isEmpty {
                                            Text("Describe your activity and how you feel now...")
                                                .font(.senti(size: 15))
                                                .opacity(0.5)
                                                .padding(7)
                                        }
                                        
                                        TextEditor(text: $description)
                                            .frame(height: 150)
                                            .font(.senti(size: 15))
                                            .onAppear {
                                                UITextView.appearance().backgroundColor = .clear
                                            }
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
                                    }
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.gray.opacity(0.3)))
                                }
                                .opacity(activity.1.isEmpty ? 0.5 : 1)
                                .disabled(activity.1.isEmpty)
                            }
                            .offset(y: keyboardHeight != 0 ? (g.size.height - textFieldYPlusHeight - (g.size.height - keyboardHeight) + 10) : 0)
                            .animation(.easeOut, value: keyboardHeight)
                            
                            GeometryReader { g2 in
                                Button {
                                    let entry = Entry(context: viewContext)
                                    entry.text = description
                                    entry.date = Date()
                                    entry.feeling = feeling
                                    entry.activity = activity.1
                                    
                                    do {
                                        try viewContext.save()
                                        print("saved context")
                                    } catch {
                                        print("In \(#function), line \(#line), save activity failed:")
                                        print(error.localizedDescription)
                                    }
                                    
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
                // addSampleData(moc: viewContext) // for debugging
                
                if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path {
                    print("Documents Directory: \(documentsPath)")
                }
                // When the keyboard appears > View slides up
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                                       object: nil,
                                                       queue: .main) { (notification) in
                    guard let userInfo = notification.userInfo,
                          let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                    
                    self.keyboardHeight = keyboardRect.height
                    
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                       object: nil,
                                                       queue: .main) { (notification) in
                    self.keyboardHeight = 0
                }
            }
        }
    }
}

struct AddActivitySheet_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView()
    }
}
