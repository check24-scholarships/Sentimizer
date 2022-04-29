//
//  Image+Extension.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 27.04.22.
//

import SwiftUI

extension View {
    public func changeColor(to color: Color) -> some View {
        self.overlay(color)
        .mask(self)
    }
}
