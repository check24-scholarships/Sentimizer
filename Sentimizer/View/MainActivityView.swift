//
//  ContentView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, 2022.
//

import SwiftUI

struct MainActivityView: View {
    @EnvironmentObject private var model: Model
    
    let testDays = ["Today", "Yesterday", "Wed, 20 Apr", "Tue, 19 Apr"]
    let testContent = ["Walk", "Lunch", "Project Work", "Gaming", "Training"]
    
    var body: some View {
        ZStack {
            K.bgColor.ignoresSafeArea() // Background Color - light gray
            ScrollView {
                Group {
                    VStack(alignment: .leading) {
                        Text("Activities")
                            .font(.senti(size: 35))
                        
                        AddActivity()
                    }
                    .padding([.top, .bottom], 25)
                    
                    ForEach(testDays, id: \.self) { day in
                        VStack(alignment: .leading) {
                            Text(day)
                                .font(.senti(size: 25))
                                .padding()
                            
                            ForEach(testContent, id: \.self) { a in
                                Activity(activity: a)
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
    }
}

struct AddActivity: View {
    var body: some View {
        NavigationLink { MainActivityView() } label: {
            HStack(spacing: 20) {
                Image(systemName: "plus.square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                Text("Add Activity")
                    .font(.senti(size: 23))
                    .bold()
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .padding()
            .padding([.leading, .trailing])
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 25).foregroundColor(K.brandColor2))
        }
    }
}

struct Activity: View {
    
    let activity: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("12:55")
                Text("30 min")
            }
            .font(.senti(size: 20))
            .padding()
            
            Text(activity)
            
            Spacer()
            
            Image(systemName: "face.smiling")
                .font(.largeTitle)
                .padding(20)
                .background(Rectangle().gradientForeground(.leading, .trailing))
        }
        .font(.senti(size: 25))
        .foregroundColor(.white)
        .background(
            Rectangle()
                .gradientForeground())
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainActivityView()
            .environmentObject(Model())
    }
}
