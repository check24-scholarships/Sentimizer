//
//  ViewTitle.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 27.04.22.
//

import SwiftUI

/// Displays the standard Sentimizer view title.
struct ViewTitle: View {
    let title: String
    
    var fontSize: CGFloat
    
    var body: some View {
        Text(title)
            .font(.senti(size: fontSize))
            .padding()
            .padding(.top, 25)
    }
    
    init(_ title: String, fontSize: CGFloat = 35) {
        self.title = title
        self.fontSize = fontSize
    }
}

struct ViewTitle_Previews: PreviewProvider {
    static var previews: some View {
        ViewTitle("Activities")
    }
}
