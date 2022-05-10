//
//  View+GradientExtension.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, 2022.
//

import SwiftUI

extension View {
    ///  Sets the foreground of any view to a linear gradient. Default values are the custom Sentimizer gradient.
    ///  - parameter colors: Collection of colors to create a linear gradient.
    public func gradientForeground(colors: [Color] = [Color("brandColor2"), Color("brandColor2Light")], _ startPoint: UnitPoint = .top, _ endPoint: UnitPoint = .bottom) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint)
        )
        .mask(self)
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
