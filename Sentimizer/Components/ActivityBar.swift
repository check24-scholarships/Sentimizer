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
    let time: (String, String)
    let sentiment: String
    let id: String
    let icon: String
    
    var body: some View {
        HStack {
            Text(time.0)
                .font(.senti(size: 20))
                .padding([.leading, .top, .bottom])
                .padding(.trailing, 3)
            
            HStack {
                Image(systemName: icon)
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(activity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .padding(.top, 5)
                        .padding(2)
                    
                    let isEmpty = description.isEmpty
                    let description = description.isEmpty ? "Describe your activity..." : description
                    Text(description)
                        .font(.senti(size: 18))
                        .opacity(isEmpty ? 0.5 : 1.0)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 10)
                        .padding(.leading, 2)
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
}

struct ActivityBar_Previews: PreviewProvider {
    static var previews: some View {
        ActivityBar(activity: "Walk", description: "", time: ("08:03", "10"), sentiment: "happy", id: "1", icon: "figure.walk")
    }
}
