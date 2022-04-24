//
//  File.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 24.04.22.
//

import SwiftUI

struct SentiButton: View {
    
    let icon: String?
    let title: String
    enum ButtonStyles {
        case filled
        case outlined
    }
    var style: ButtonStyles = .filled
    var fontSize: CGFloat = 23
    var textColor: Color = .white
    
    var body: some View {
        HStack(spacing: 20) {
            if let icon = icon {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
            }
            Text(title)
                .font(.senti(size: fontSize))
                .bold()
                .multilineTextAlignment(.leading)
            Spacer()
            Image(systemName: "chevron.forward")
        }
        .padding()
        .padding(.leading, 5)
        .padding(.trailing)
        .foregroundColor(textColor)
        .background(RoundedRectangle(cornerRadius: 25).foregroundColor(style == .filled ? K.brandColor2 : .clear))
        .overlay(RoundedRectangle(cornerRadius: 25)
            .stroke(style == .outlined ? K.brandColor2 : .clear, lineWidth: 3))
    }
}
