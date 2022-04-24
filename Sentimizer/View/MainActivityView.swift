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
    let testContent = (["Walk", "Lunch", "Project Work", "Gaming", "Training"], ["Omg i feel so good and fresh now just like a fresh watermelon", "Mmmhh Lasagna", "I. HATE. THIS. PROJECT.", nil, "Wow my sixpack is so sexy"])
    
    var body: some View {
        ZStack {
            K.bgColor.ignoresSafeArea()
            ScrollView {
                Group {
                    VStack(alignment: .leading) {
                        Text("Activities")
                            .font(.senti(size: 35))
                        
                        SentiButton(icon: "plus.circle", title: "Add Activity")
                            .onTapGesture {
                                addActivitySheetOpened = true
                            }
                    }
                    .padding([.top, .bottom], 25)
                    
                    ForEach(testDays, id: \.self) { day in
                        VStack(alignment: .leading) {
                            Text(day)
                                .font(.senti(size: 25))
                                .padding()
                            
                            let testCount = [0, 1, 2, 3, 4]
                            ForEach(testCount, id: \.self) { i in
                                Activity(activity: testContent.0[i], description: testContent.1[i])
                            }
                        }
                    }
                }
                .padding([.leading, .trailing], 25)
            }
            .foregroundColor(K.textColor)
            .shadow(radius: 10)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $addActivitySheetOpened) {
            AddActivitySheet(presented: $addActivitySheetOpened)
        }
    }
}

//MARK: - Activity Bar
struct Activity: View {
    
    let activity: String
    let description: String?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("12:55")
                Text("30 min")
            }
            .font(.senti(size: 20))
            .padding()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(activity)
                    .padding([.top, .bottom], 5)
                if let description = description {
                    Text(description)
                        .font(.senti(size: 18))
                        .opacity(0.7)
                        .lineLimit(2)
                        .padding(.bottom, 10)
                }
            }
            
            Spacer()
            
            Image(systemName: "face.smiling")
                .font(.largeTitle)
                .padding(20)
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
