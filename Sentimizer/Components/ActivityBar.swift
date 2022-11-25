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
    
    var showsTime: Bool = true
    
    @State private var brandColor2 = Color.brandColor2
    @State private var brandColor2Light = Color.brandColor2Light
    
    var body: some View {
        
        let descriptionEmpty = activity.description.isEmpty
        
        HStack {
            Text(time)
                .font(.sentiBold(size: 20))
                .padding([.leading, .top, .bottom])
                .padding(.trailing, 3)
                .opacity(showsTime ? 1 : 0)
            
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
                            .font(.sentiBold(size: 18))
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
            .font(.sentiBold(size: 25))
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
        ActivityBar(activity: ActivityData(id: "", activity: "Walk", icon: "figure.walk", date: Date(), description: "", sentiment: "happy"), activityName: "Walk", time: "08:03")
    }
}
