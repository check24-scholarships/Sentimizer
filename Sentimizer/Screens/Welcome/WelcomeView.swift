//
//  WelcomeView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 05.06.22.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var done = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ZStack {
                        // Shape to fill upper part
                        Color.brandColor2.frame(width:500, height:150)
                            .ignoresSafeArea()
                        VStack {
                            // System icons as background
                            ForEach(0...1, id: \.self) { i in
                                HStack {
                                    ForEach(0..<K.defaultActivities.1.count-6, id: \.self) { j in
                                        Image(systemName: i == 0 ? K.defaultActivities.1.reversed()[j] : K.defaultActivities.1[j])
                                            .standardIcon(shouldBeMaxWidthHeight: true, maxWidthHeight: 30)
                                            .foregroundColor(.black.opacity(0.9))
                                            .opacity(0.1)
                                            .padding()
                                    }
                                }
                            }
                        }
                        
                        // Sentimizer gradient font
                        Text("Sentimizer")
                            .font(.senti(size: 50))
                            .fontWeight(.bold)
                            .gradientForeground(colors: [.brandColor1, .brandColor4], .leading, .trailing)
                            .shadow(radius: 10)
                            .padding(30)
                            .ignoresSafeArea()
                    }
                    .background(Ellipse().frame(width: 700, height:220).foregroundColor(.brandColor2).ignoresSafeArea())
                   
                    // Screentext
                    VStack(alignment: .leading) {
                        Text("Optimize Your Life!")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.senti(size: 28))
                            .fontWeight(.bold)
                            .padding(.top, 40)
                            .padding(.bottom)
                        
                        HStack{
                            Image(systemName: "hand.thumbsup")
                                .padding()
                            Text("Sentimizer helps you to track your moods, reflect on your day and improve your life. Let's go!")
                                .font(.senti(size: 20))
                                .padding(.trailing)
                                .padding(.top)
                            }
                        
                        HStack{
                            Image(systemName: "lock")
                                .padding()
                            Text("Your privacy is very important to us. Data is stored only on your mobile phone, so you are in complete control.")
                                .font(.senti(size: 20))
                                .padding(.trailing)
                                .padding(.top)
                        }
                        Spacer()
                    }
                    
                    
                    
                    Spacer()
                    // jump to second screen on button click
                    NavigationLink {
                        WelcomeView2(done: $done)
                    } label: {
                        SentiButton(icon: nil, title: "Start My Journey", chevron: true, leading: true)
                            .padding(20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        // dismisses all screens when done
        .onChange(of: done) { newValue in
            if done {
                dismiss()
            }
        }
    }
}

struct WelcomeView2: View {
    @Binding var done: Bool
    
    @State private var nickname = ""
    @State private var textFieldEditing = false
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.bgColor.ignoresSafeArea()
                VStack {
                    Text("Nice to meet you! What do your friends call you?")
                        .font(.senti(size: 25))
                        .fontWeight(.semibold)
                        .frame(height: 60)
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding(.top)
                    
                    SentiWelcomeTextField(placeholder: "Your name", text: $nickname, textFieldEditing: $textFieldEditing, done: .constant(false))
                        .font(.senti(size: 35))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 50)
                        // automatically call keyboard on next screen
                        .focused($keyboardFocused)
                    
                    Divider()
                        .padding(.horizontal)

                    Spacer()
                    
                    NavigationLink {
                        WelcomeView3(done: $done)
                    } label: {
                        SentiButton(icon: nil, title: "Continue", chevron: true, leading: true)
                            .padding(.horizontal, 20)
                            .padding(.bottom)
                    }
                    .opacity(nickname.map{$0 != " "}.isEmpty ? 0.5 : 1)
                    .disabled(nickname.map{$0 != " "}.isEmpty)
                }
                .onTapGesture {
                    textFieldEditing = false
                }
                .simultaneousGesture(
                    DragGesture().onChanged { value in
                        textFieldEditing = false
                    }
                )
                .onChange(of: textFieldEditing) { newValue in
                    UserDefaults.standard.set(nickname, forKey: K.userNickname)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            keyboardFocused = true
        }
    }
}

struct WelcomeView3: View {
    @Binding var done: Bool
    
    let welcomeImages = ["welcome1", "welcome2", "welcome3", "welcome4", "welcome5"]
    let welcomeTexts = [Text("\(Image(systemName: "figure.walk")) After doing something, save the activity in Sentimizer"), Text("\(Image(systemName: "flowchart.fill")) Sentimizer will keep track of your activities"), Text("\(Image(systemName: "chart.line.uptrend.xyaxis")) \(Image(systemName: "face.smiling")) After some time, Sentimizer will recommend you to do something that boosts your mood"), Text("\(Image(systemName: "calendar.badge.clock")) Use the calendar to get an overview of your habits and to plan for the future"), Text("\(Image(systemName: "calendar.day.timeline.left")) Sentimizer uses Machine Learning to discover your habits and recommends you to change them to improve your wellbeing")]
    
    @State private var selection = 0
    
    var body: some View {
        ZStack {
            Color.bgColor.ignoresSafeArea()
            VStack {
                Spacer()
                
                TabView(selection: $selection) {
                    ForEach(0..<welcomeImages.count, id: \.self) { i in
                        VStack {
                            Spacer()
                            
                            Image(welcomeImages[i])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .padding()
                                .shadow( radius: 10, x: -5, y: -5)
                            
                            welcomeTexts[i]
                                .font(.senti(size: 20))
                                .fontWeight(.bold)
                                .padding()
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                            
                            if selection == welcomeImages.count-1 {
                                Button {
                                    UserDefaults.standard.set(true, forKey: K.welcomeScreenShown)
                                    done = true
                                } label: {
                                    SentiButton(icon: nil, title: "Let's go!", chevron: true, leading: true)
                                        .padding(20)
                                        .padding(.bottom, 60)
                                        .transaction { transaction in
                                            transaction.animation = nil
                                        }
                                }
                            } else {
                                HStack {
                                    Button {
                                        if selection > 0 {
                                            withAnimation {
                                                selection -= 1
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "arrow.left.circle")
                                            .standardIcon(width: 40)
                                            .padding(.leading)
                                            .gradientForeground(colors: [.brandColor2, .brandColor2Light])
                                    }
                                    .opacity(selection < 1 ? 0.3 : 1)
                                    .disabled(selection < 1)
                                    
                                    Spacer()
                                    
                                    Button {
                                        if selection < welcomeImages.count {
                                            withAnimation {
                                                selection += 1
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "arrow.right.circle")
                                            .standardIcon(width: 40)
                                            .padding(.trailing)
                                            .gradientForeground(colors: [.brandColor2, .brandColor2Light])
                                    }
                                    .opacity(selection > welcomeImages.count-1 ? 0.3 : 1)
                                    .disabled(selection > welcomeImages.count-1)
                                }
                                .padding()
                                .padding(.bottom, 60)
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
