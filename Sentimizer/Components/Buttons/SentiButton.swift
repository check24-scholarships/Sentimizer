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
    var leading: Bool = false
    var shadow: Bool = true
    
    var body: some View {
        HStack(spacing: 20) {
            if !chevron && !leading {
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
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.leading)
            Spacer()
            if chevron {
                Image(systemName: "chevron.forward")
            }
        }
        .padding()
        .padding(.leading, 5)
        .padding(.trailing)
        .foregroundColor(textColor)
        .background(RoundedRectangle(cornerRadius: 25)
            .foregroundColor(style == .filled ? .brandColor2 : .clear)
            .shadow(color: .gray.opacity(shadow ? 0.7 : 0), radius: 10))
        .overlay(RoundedRectangle(cornerRadius: 25)
            .stroke(style == .outlined ? Color.brandColor2 : .clear, lineWidth: 3)
            .shadow(color: .gray.opacity(shadow ? 0.7 : 0), radius: 10))
    }
}

struct SentiButton_Previews: PreviewProvider {
    static var previews: some View {
        SentiButton(icon: "plus.circle", title: "Add", style: .outlined, textColor: .gray, chevron: false, leading: true)
    }
}
