//
//  Image+Extension.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 25.05.22.
//

import SwiftUI

extension Image {
    /// Sets the standard properties for an Icon: resizable, content mode fit, frame dimensions.
    public func standardIcon(width: CGFloat = 30, shouldBeMaxWidthHeight: Bool = false, maxWidthHeight: CGFloat = 12) -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: shouldBeMaxWidthHeight ? nil : width)
            .frame(maxWidth: shouldBeMaxWidthHeight ? maxWidthHeight : nil)
            .frame(maxHeight: shouldBeMaxWidthHeight ? maxWidthHeight : nil)
    }
    
    /// Returns the standard Sentimizer icon design for settings screens.
    public func standardSentiSettingsIcon(foregroundColor: Color, backgroundColor: Color) -> some View {
        self.standardIcon(width: 20)
            .padding(10)
            .foregroundColor(foregroundColor)
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(backgroundColor))
    }
}
