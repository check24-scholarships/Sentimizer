//
//  ContentView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, 2022.
//

import SwiftUI

struct MainActivityView: View {
    @EnvironmentObject private var model: Model
    
    @State var addActivitySheetOpened = false
    
    let testDays = ["Today", "Yesterday", "Wed, 20 Apr", "Tue, 19 Apr"]
    let testContent = (["Walk", "Lunch", "Project Work", "Gaming", "Training"], ["Omg i feel so good and fresh now just like a fresh watermelon", "Mmmhh Lasagna", "I. HATE. THIS. PROJECT.", nil, "Wow my sixpack is so sexy"], [Color.green, Color.yellow, Color.blue, Color.purple, Color.gray], K.sentimentsArray)
    
    var body: some View {
        ZStack {
            K.bgColor.ignoresSafeArea()
            ScrollView {
                Group {
                    VStack(alignment: .leading) {
                        ViewTitle("Activities")
                            .padding()
                        
                        SentiButton(icon: "plus.circle", title: "Add Activity")
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .onTapGesture {
                                addActivitySheetOpened = true
                            }
                    }
                    .padding(.vertical, 25)
                    
                    ForEach(testDays, id: \.self) { day in
                        VStack(alignment: .leading) {
                            Text(day)
                                .font(.senti(size: 25))
                                .padding()
                            
                            let testCount = [0, 1, 2, 3, 4]
                            ForEach(testCount, id: \.self) { i in
                                Activity(activity: testContent.0[i], description: testContent.1[i], color: testContent.2[i], sentiment: testContent.3[i])
                            }
                        }
                    }
                }
                .padding(.horizontal, 15)
            }
            .foregroundColor(K.textColor)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $addActivitySheetOpened) {
            AddActivityView()
        }
    }
}

//MARK: - Activity Bar
struct Activity: View {
    
    let activity: String
    let description: String?
    let color: Color
    let sentiment: String
    
    @State var width: CGFloat = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("12:55")
                Text("30 min")
            }
            .font(.senti(size: 20))
            .padding([.leading, .top, .bottom])
            .padding(.trailing, 3)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(activity)
                    .padding(.top, 5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .overlay {
                        GeometryReader { g in
                            Color.clear
                                .onAppear {
                                    width = g.frame(in: .local).width
                                    print(width)
                                }
                                .onChange(of: g.frame(in: .local).width) { newValue in
                                    width = newValue
                                    print(width)
                                }
                        }
                    }
                Rectangle()
                    .frame(width: width, height: 5)
                    .foregroundColor(color)
                if let description = description {
                    Text(description)
                        .font(.senti(size: 18))
                        .opacity(0.7)
                        .lineLimit(2)
                        .padding(.bottom, 10)
                }
            }
            
            Spacer()

            Image(sentiment)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
                .padding(15)
                .changeColor(to: .white)
                .background(Rectangle().gradientForeground(.leading, .trailing).frame(height: 100))
        }
        .font(.senti(size: 25))
        .foregroundColor(.white)
        .background(
            Rectangle()
                .gradientForeground())
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct MainActivityView_Previews: PreviewProvider {
    static var previews: some View {
        MainActivityView()
            .environmentObject(Model())
    }
}
