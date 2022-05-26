//
//  Color+Extension.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 02.05.22.
//

import SwiftUI

extension Color {
    static let bgColor = Color("bgColor")
    static let brandColor1 = Color("brandColor1")
    static let brandColor2 = Color("brandColor2")
    static let brandColor2Light = Color("brandColor2Light")
    static let brandColor3 = Color("brandColor3")
    static let brandColor4 = Color("brandColor4")
    static let textColor = Color("textColor")
    static let dayViewBgColor = Color("dayViewBg")
    
    func adjust(hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, opacity: CGFloat = 1) -> Color {
        let color = UIColor(self)
        var currentHue: CGFloat = 0
        var currentSaturation: CGFloat = 0
        var currentBrigthness: CGFloat = 0
        var currentOpacity: CGFloat = 0

        if color.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentOpacity) {
            return Color(hue: currentHue + hue, saturation: currentSaturation + saturation, brightness: currentBrigthness + brightness, opacity: currentOpacity + opacity)
        }
        return self
    }
}
