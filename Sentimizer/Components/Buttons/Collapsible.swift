//
//  Collapsible.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 20.08.22.
//

import SwiftUI

struct Collapsible<Content: View>: View {
    @State var label: () -> Text
    @State var content: () -> Content
    
    @State private var collapsed: Bool = true
    
    var body: some View {
        VStack {
            Button {
                withAnimation(.easeOut) {
                    self.collapsed.toggle()
                }
            } label: {
                HStack {
                    self.label()
                    
                    Spacer()
                    
                    Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
                }
                .padding(.bottom, 1)
                .background(Color.white.opacity(0.01))
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack {
                self.content()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
            .clipped()
            .transition(.slide)
        }
    }
}
