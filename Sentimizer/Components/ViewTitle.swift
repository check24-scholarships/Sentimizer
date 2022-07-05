//
//  ViewTitle.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 27.04.22.
//

import SwiftUI

/// Displays the standard Sentimizer view title.
struct ViewTitle: View {
    let title: LocalizedStringKey
    var padding: Bool
    
    var fontSize: CGFloat
    
    var body: some View {
        Text(title)
            .font(.senti(size: fontSize))
            .padding(padding ? 10 : 0)
            .padding(.top, padding ? 25 : 0)
    }
    
    init(_ title: LocalizedStringKey, padding: Bool = true, fontSize: CGFloat = 35) {
        self.title = title
        self.padding = padding
        self.fontSize = fontSize
    }
}

struct ViewTitle_Previews: PreviewProvider {
    static var previews: some View {
        ViewTitle("Activities")
    }
}
