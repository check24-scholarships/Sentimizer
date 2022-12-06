//
//  ActivityBar.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 19.05.22.
//

import SwiftUI

struct ActivityBar: View {
    
    let activity: ActivityData
    let activityName: LocalizedStringKey
    let time: String
    let duration: Int16
    
    var showsTime: Bool = true
    
    @State private var brandColor2 = Color.brandColor2
    @State private var brandColor2Light = Color.brandColor2Light
    
    var body: some View {
        
        let descriptionEmpty = activity.description.isEmpty
        
        HStack {
            VStack {
                Text(time)
                    .opacity(showsTime ? 1 : 0)
                
                if duration > 0 {
                    let durationHours = String(Int(duration/60))
                    let durationMinutes = String(duration%60)
                    
                    if durationHours != "0" {
                        Text("\(durationHours.count == 1 ? "0" : "")\(durationHours):\(durationMinutes.count == 1 ? "0" : "")\(durationMinutes) h")
                    } else {
                        Text("\(durationMinutes) min")
                    }
                }
            }
            .font(.senti(size: 20))
            .padding(.leading)
            .if(duration > 0) { vStack in
                vStack.padding([.bottom, .top])
            }
            .padding(.trailing, 3)
            
            HStack {
                Image(systemName: activity.icon)
                    .standardIcon(shouldBeMaxWidthHeight: true, maxWidthHeight: 30)
                    .padding(.leading, descriptionEmpty ? 10 : 15)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(activityName)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .padding(.top, descriptionEmpty ? 0 : 5)
                        .padding(2)
                    
                    if !descriptionEmpty {
                        Text(activity.description)
                            .font(.senti(size: 18))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 10)
                            .padding(.leading, 2)
                            .foregroundColor(.textColor)
                    }
                }
                
                Spacer()
                
                Image(activity.sentiment)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                    .padding(descriptionEmpty ? 10 : 15)
                    .changeColor(to: .brandColor2)
            }
            .font(.senti(size: 25))
            .fontWeight(.bold)
            .foregroundColor(brandColor2)
            .background(
                RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 4)
                    .gradientForeground(colors: [.brandColor2, brandColor2Light]))
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .onAppear {
            brandColor2 = Color.brandColor2
            brandColor2Light = Color.brandColor2Light
        }
    }
}

struct ActivityBar_Previews: PreviewProvider {
    static var previews: some View {
        ActivityBar(activity: ActivityData(id: "", activity: "Walk", icon: "figure.walk", date: Date(), duration: 20000, description: "", sentiment: "happy"), activityName: "Walk", time: "08:03", duration: 234)
    }
}
