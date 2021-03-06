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
                Color.bgColor.ignoresSafeArea()
                VStack {
                    ZStack {
                        VStack {
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
                        
                        Text("Sentimizer")
                            .font(.senti(size: 50))
                            .gradientForeground(colors: [.brandColor1, .brandColor4], .leading, .trailing)
                            .shadow(radius: 10)
                            .padding(30)
                    }
                    .background(Rectangle().frame(width: 1000).foregroundColor(.brandColor2).ignoresSafeArea())
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Optimize Your Life")
                                .font(.senti(size: 28))
                                .padding(20)
                            
                            Text("Sentimizer helps you to track your moods, reflect on your day and improve your life. Let's go!")
                                .font(.senti(size: 20))
                                .padding()
                                .padding(.top)
                        }
                        Spacer()
                    }
                    
                    
                    
                    Spacer()
                    
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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.bgColor.ignoresSafeArea()
                VStack {
                    Text("Nice to meet you! What do your friends call you?")
                        .font(.senti(size: 23))
                        .frame(height: 60)
                    
                    SentiTextField(placeholder: "Your nickname...", text: $nickname, textFieldEditing: $textFieldEditing, done: .constant(false))
                        .padding()
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    NavigationLink {
                        WelcomeView3(done: $done)
                    } label: {
                        SentiButton(icon: nil, title: "Continue", chevron: true, leading: true)
                            .padding(.horizontal, 20)
                            .padding(.bottom)
                    }
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
