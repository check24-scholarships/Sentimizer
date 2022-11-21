//
//  Color+Extension.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 02.05.22.
//

import SwiftUI

extension Color {
    
    static var bgColor: Color { Color(UserDefaults.standard.bool(forKey: K.colorTheme) ? "bgColor" : "bgColor2") }
    static var brandColor1: Color { Color(UserDefaults.standard.bool(forKey: K.colorTheme) ? "brandColor1" : "brandColor12") }
    static var brandColor2: Color { Color(UserDefaults.standard.bool(forKey: K.colorTheme) ? "brandColor2" : "brandColor22") }
    static var brandColor2Light: Color { Color(UserDefaults.standard.bool(forKey: K.colorTheme) ? "brandColor2Light" : "brandColor2Light2") }
    static var brandColor3: Color { Color(UserDefaults.standard.bool(forKey: K.colorTheme) ? "brandColor3" : "brandColor32") }
    static var brandColor4: Color { Color(UserDefaults.standard.bool(forKey: K.colorTheme) ? "brandColor4" : "brandColor42") }
    static var textColor: Color { Color(UserDefaults.standard.bool(forKey: K.colorTheme) ? "textColor" : "textColor2") }
    static var dayViewBgColor: Color { Color(UserDefaults.standard.bool(forKey: K.colorTheme) ? "dayViewBg" : "dayViewBg2") }
    static var tabBarColor: Color { Color(UserDefaults.standard.bool(forKey: K.colorTheme) ? "tabBarColor" : "tabBarColor2") }
    
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
