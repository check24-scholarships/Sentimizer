//
//  ActivityBar.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 19.05.22.
//

import SwiftUI

struct ActivityBar: View {
    
    let activity: String
    let description: String
    let time: String
    var showsTime: Bool = true
    let sentiment: String
    let id: String
    let icon: String
    
    @State private var brandColor2 = Color.brandColor2
    @State private var brandColor2Light = Color.brandColor2Light
    
    var body: some View {
        HStack {
            Text(time)
                .font(.senti(size: 20))
                .padding([.leading, .top, .bottom])
                .padding(.trailing, 3)
                .opacity(showsTime ? 1 : 0)
            
            HStack {
                Image(systemName: icon)
                    .standardIcon(shouldBeMaxWidthHeight: true, maxWidthHeight: 30)
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(activity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .padding(.top, 5)
                        .padding(2)
                    
                    let isEmpty = description.isEmpty
                    let description: LocalizedStringKey = description.isEmpty ? "Describe your activity..." : LocalizedStringKey(description)
                    Text(description)
                        .font(.senti(size: 18))
                        .opacity(isEmpty ? 0.5 : 1.0)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 10)
                        .padding(.leading, 2)
                        .foregroundColor(.textColor)
                }
                Spacer()
                Image(sentiment)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                    .padding(15)
                    .changeColor(to: .brandColor2)
//                    .background(Rectangle().gradientForeground(.leading, .trailing).frame(height: 100))
            }
            .font(.senti(size: 25))
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
        ActivityBar(activity: "Walk", description: "", time: "08:03", sentiment: "happy", id: "1", icon: "figure.walk")
    }
}
