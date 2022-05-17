//
//  MoodPicker.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 17.05.22.
//

import SwiftUI

struct MoodPicker: View {
    let width: CGFloat
    var opaque: Bool = false
    
    @Binding var feeling: String
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                feeling = K.sentimentsArray[0]
            } label: {
                Image(K.sentimentsArray[0])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width/5 - 30)
                    .padding(10)
                    .padding(.leading, 7)
                    .background(feeling == K.sentimentsArray[0] ? Rectangle().foregroundColor(K.sentimentColors[0].opacity(opaque ? 0.5 : 0.3)).frame(height: 100) : nil)
            }
            ForEach(1..<K.sentimentsArray.count, id: \.self) { index in
                HStack(spacing: 0) {
                    Divider()
                        .frame(height: width/5 - 30)
                    Button {
                        feeling = K.sentimentsArray[index]
                    } label: {
                        Image(K.sentimentsArray[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width/5 - 30)
                            .padding(10)
                            .padding(.trailing, index == K.sentimentsArray.count-1 ? 7 : 0)
                            .background(feeling == K.sentimentsArray[index] ? Rectangle().foregroundColor(K.sentimentColors[index].opacity(opaque ? 0.4 : 0.2)).frame(height: 100) : nil)
                    }
                }
            }
        }
        .padding(.vertical, 7)
        .background(RoundedRectangle(cornerRadius: 25)
            .gradientForeground(colors: [K.brandColor2, K.brandColor2Light], .leading, .trailing).opacity(opaque ? 0.7 : 1)
            .shadow(radius: 10))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct MoodPicker_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { g in
            MoodPicker(width: g.size.width, feeling: .constant("happy"))
        }
    }
}
