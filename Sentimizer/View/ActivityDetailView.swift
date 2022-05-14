//
//  ActivityDetailView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 13.05.22.
//

import SwiftUI

struct ActivityDetailView: View {
    
    let activity: String
    let icon: String
    let sentiment: String
    let description: String
    let date: Date
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text(DataController.formatDate(date: date, format: "EEE, d MMM"))
                        .font(.senti(size: 20))
                    Text(DataController.formatDate(date: date, format: "HH:mm"))
                        .font(.senti(size: 18))
                }
                .padding(.vertical)
                    
                HStack {
                    Image(systemName: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45)
                    Text(activity)
                        .font(.senti(size: 23))
                        .padding(.leading)
                }
                .padding(.vertical)
                
                Image(K.sentimentsArray.filter { $0 == sentiment }[0])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 55)
                    .gradientForeground()
                
                Text(description)
                    .font(.senti(size: 18))
            }
            .padding(.horizontal, 15)
        }
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activity: "Walking", icon: "figure.walk", sentiment: "content", description: "Helloooooo im walking yesss so much fun", date: .now)
    }
}
