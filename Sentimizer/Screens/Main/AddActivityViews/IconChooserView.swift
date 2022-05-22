//
//  IconChooserView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import SwiftUI

struct IconChooser: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var done: Bool
    @Binding var iconName: String
    
    var columns: [GridItem] =
    [.init(.adaptive(minimum: 40, maximum: 55))]
    @State private var imageBounds: CGSize = CGSize(width: 35, height: 35)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ViewTitle("Choose your icon", fontSize: 30)
                
                ForEach(K.defaultIcons, id: \.0.self) { category in
                    Text(category.0.uppercased())
                        .font(.senti(size: 12))
                        .padding(.top)
                    
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(category.1, id: \.self) { icon in
                            Group {
                                Image(systemName: icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(5)
                                    .overlay(
                                        GeometryReader { g in
                                            Color.clear
                                                .onAppear {
                                                    imageBounds = g.size
                                                }
                                        }
                                    )
                                    .frame(width: imageBounds.width > imageBounds.height ? imageBounds.width : imageBounds.height,
                                           height: imageBounds.width > imageBounds.height ? imageBounds.width : imageBounds.height)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .opacity(iconName == icon ? 0.5 : 0)
                                            .gradientForeground()
                                    )
                                    .onTapGesture {
                                        iconName = icon
                                    }
                            }
                        }
                    }
                }
                .padding(.horizontal, 2)
                
                Button {
                    dismiss()
                    done = true
                } label: {
                    SentiButton(icon: nil, title: "Done", fontSize: 15, chevron: false)
                        .frame(width: 150)
                }
                .padding(.top, 20)
                .frame(maxWidth: .infinity)
                .disabled(iconName.isEmpty)
                .opacity(iconName.isEmpty ? 0.3 : 1)
                .animation(.easeOut, value: iconName)
            }
            .padding(.horizontal, 15)
        }
    }
    
    struct IconBackground: View {
        let full: Bool
        
        var body: some View {
            if full {
                RoundedRectangle(cornerRadius: 10)
                    .opacity(0.5)
                    .gradientForeground()
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .opacity(0.5)
                    .gradientForeground()
            }
        }
    }
}
