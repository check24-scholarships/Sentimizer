//
//  WhatNext.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 08.05.22.
//

import SwiftUI

struct WhatNext: View {
    let activity: String
    var backgroundGray = false
    
    @State private var brandColor2 = Color.brandColor2
    @State private var brandColor2Light = Color.brandColor2Light
    
    var body: some View {
        VStack {
            Text("What should I do next?")
                .font(.senti(size: 23))
                .gradientForeground(colors: [brandColor2, brandColor2Light])
//            Text("(Demo Data)")
//                .font(.senti(size: 15))
//                .gradientForeground()
            Text("Sentimizer recommends this activity:")
                .font(.senti(size: 15))
                .opacity(0.7)
            SentiButton(icon: "figure.walk", title: LocalizedStringKey(activity), style: .outlined, chevron: false, shadow: false)
                .gradientForeground(colors: [brandColor2, brandColor2Light])
                .scaleEffect(0.8)
        }
        .padding()
        .if(backgroundGray) { view in
            view.standardBackground()
        } else: { view in
            view.background(RoundedRectangle(cornerRadius: 25).foregroundColor(.dayViewBgColor).opacity(0.8))
        }
        .onAppear {
            brandColor2 = Color.brandColor2
            brandColor2Light = Color.brandColor2Light
        }
    }
}

struct WhatNext_Previews: PreviewProvider {
    static var previews: some View {
        WhatNext(activity: "Walking")
    }
}
