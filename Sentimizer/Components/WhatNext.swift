//
//  WhatNext.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 08.05.22.
//

import SwiftUI

struct WhatNext: View {
    let activity: String
    
    var body: some View {
        VStack {
            Text("What should I do next?")
                .font(.senti(size: 23))
                .gradientForeground()
            Text("Sentimizer recommends this activity:")
                .font(.senti(size: 15))
                .opacity(0.7)
            SentiButton(icon: "figure.walk", title: activity, chevron: false)
                .scaleEffect(0.8)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25).foregroundColor(K.dayViewBgColor).opacity(0.8))
    }
}

struct WhatNext_Previews: PreviewProvider {
    static var previews: some View {
        WhatNext(activity: "Walking")
    }
}