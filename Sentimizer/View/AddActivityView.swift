//
//  AddActivityView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 24.04.22.
//

import SwiftUI

struct AddActivityView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var keyboardHeight: CGFloat = 0
    @State var textFieldYPlusHeight: CGFloat = 0
    
    @State var description = ""
    
    var body: some View {
        GeometryReader { g in
            NavigationView {
                ZStack(alignment: .topLeading) {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Group {
                                ViewTitle("Add Activity")
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 50)
                                
                                NavigationLink {
                                    ActivityChooser()
                                        .offset(y: -10) // !!! (swiftUI bug?)
                                } label: {
                                    SentiButton(icon: nil, title: "Choose Activity", style: .outlined, fontSize: 20, textColor: .gray)
                                }
                                .padding(.top, 40)
                                
                                Text("How do you feel?")
                                    .font(.senti(size: 25))
                                    .padding(.top, 30)
                                    .padding(.leading)
                                
                                HStack {
                                    Spacer()
                                    ForEach(K.sentimentsArray, id: \.self) { sent in
                                        HStack(spacing: 0) {
                                            if sent != K.sentimentsArray[0] {
                                                Divider()
                                                    .frame(height: g.size.width/5 - 10)
                                                    .padding(.trailing, 12)
                                            }
                                            Image(sent)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: g.size.width/5 - 40)
                                                .padding(.trailing, 7)
                                                .padding(.vertical)
                                        }
                                        
                                    }
                                    Spacer()
                                }
                                .background(RoundedRectangle(cornerRadius: 25)
                                    .gradientForeground(.leading, .trailing)
                                    .shadow(radius: 10))
                                
                                
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
                                    textFieldYPlusHeight = g2.frame(in: CoordinateSpace.global).origin.y - 30
                                }
                                .onChange(of: g2.frame(in: CoordinateSpace.global).origin.y) { newValue in
                                    textFieldYPlusHeight = newValue - 30
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
