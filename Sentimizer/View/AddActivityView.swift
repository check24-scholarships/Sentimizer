//
//  AddActivityView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 24.04.22.
//

import SwiftUI

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
                        VStack(alignment: .leading) {
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
                                
                                Text("How do you feel?")
                                    .font(.senti(size: 25))
                                    .padding(.top, 30)
                                    .padding(.leading)
                                
                                HStack(spacing: 0) {
                                    Spacer()
                                    ForEach(K.sentimentsArray, id: \.self) { sent in
                                        HStack(spacing: 0) {
                                            if sent != K.sentimentsArray[0] {
                                                Divider()
                                                    .frame(height: g.size.width/5 - 10)
                                                    .padding(.trailing, 12)
                                            }
                                            Button {
                                                feeling = sent
                                            } label: {
                                                Image(sent)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: g.size.width/5 - 35)
                                                    .padding(.trailing, 12)
                                                    .padding(.vertical)
                                                    .padding(.leading, 12)
                                                    .background(feeling == sent ? Rectangle().foregroundColor(K.brandColor2.adjust(brightness: -0.1)).frame(height: 100) : nil)
                                                    .padding(.leading, -12)
                                            }
                                        }
                                        
                                    }
                                    Spacer()
                                }
                                .background(RoundedRectangle(cornerRadius: 25)
                                    .gradientForeground(.leading, .trailing)
                                    .shadow(radius: 10))
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                
                                
                                Text("What's happening?")
                                    .font(.senti(size: 25))
                                    .padding(.top, 30)
                                    .padding(.leading)
                                
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
                            .offset(y: keyboardHeight != 0 ? (g.size.height - textFieldYPlusHeight - (g.size.height - keyboardHeight)) : 0)
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
                                .disabled(feeling.isEmpty || activity.1.isEmpty)
                                .onAppear {
                                    textFieldYPlusHeight = g2.frame(in: CoordinateSpace.global).origin.y
                                }
                                .onChange(of: g2.frame(in: CoordinateSpace.global).origin.y) { newValue in
                                    textFieldYPlusHeight = newValue
                                }
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
