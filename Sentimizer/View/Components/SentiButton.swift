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
    var chevron: Bool = true
    
    var body: some View {
        HStack(spacing: 20) {
            if !chevron {
                Spacer()
            }
            if let icon = icon {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            }
            Text(title)
                .font(.senti(size: fontSize))
                .bold()
                .multilineTextAlignment(.leading)
            if chevron {
                Spacer()
                Image(systemName: "chevron.forward")
            } else {
                Spacer()
            }
        }
        .padding()
        .padding(.leading, 5)
        .padding(.trailing)
        .foregroundColor(textColor)
        .background(RoundedRectangle(cornerRadius: 25)
            .foregroundColor(style == .filled ? K.brandColor2 : .clear)
            .shadow(radius: 10))
        .overlay(RoundedRectangle(cornerRadius: 25)
            .stroke(style == .outlined ? K.brandColor2 : .clear, lineWidth: 3)
            .shadow(radius: 10))
    }
}
