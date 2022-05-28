//
//  SwiftUIView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 28.05.22.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        ZStack {
//            Color.bgColor.ignoresSafeArea()
            VStack {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .frame(width: 200)
//                    .shadow(radius: 10)
//                Text("Sentimizer")
//                    .foregroundColor(.gray.adjust(brightness: -0.1))
//                    .font(.senti(size: 40))
            }
                
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
            .previewDevice("iPhone 13")
    }
}

