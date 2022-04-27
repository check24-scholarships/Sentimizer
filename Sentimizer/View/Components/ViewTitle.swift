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
    
    var body: some View {
        Text(title)
            .font(.senti(size: 35))
    }
    
    init(_ title: String) {
        self.title = title
    }
}

struct ViewTitle_Previews: PreviewProvider {
    static var previews: some View {
        ViewTitle("Activities")
    }
}
