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
    
    /// Sets the background of any view to a rounded rectangle with low opacity.
    public func standardBackground() -> some View {
        self.background {
            RoundedRectangle(cornerRadius: 25).foregroundColor(.brandColor1).opacity(0.1)
        }
    }
    
    /// Colors all the pixels of the specified view.
    public func changeColor(to color: Color) -> some View {
        self.overlay(color)
            .mask(self)
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @ViewBuilder
    func ifCondition<TrueContent: View, FalseContent: View>(_ condition: Bool, then trueContent: (Self) -> TrueContent, else falseContent: (Self) -> FalseContent) -> some View {
        if condition {
            trueContent(self)
        } else {
            falseContent(self)
        }
    }
    
    @ViewBuilder
        func ifCondition<TrueContent: View>(_ condition: Bool, then trueContent: (Self) -> TrueContent) -> some View {
            if condition {
                trueContent(self)
            } else {
                self
            }
        }
}
