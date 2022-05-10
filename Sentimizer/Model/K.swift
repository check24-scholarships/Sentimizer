//
//  K.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, Justin Hohenstein, Henry Pham, 2022.
//

import SwiftUI

struct K {
    static let bgColor = Color("bgColor")
    static let brandColor1 = Color("brandColor1")
    static let brandColor2 = Color("brandColor2")
    static let brandColor2Light = Color("brandColor2Light")
    static let brandColor3 = Color("brandColor3")
    static let brandColor4 = Color("brandColor4")
    static let textColor = Color("textColor")
    static let dayViewBgColor = Color("dayViewBg")
    
    enum Sentiments: Double {
        case crying = 0.0
        case sad = 0.25
        case neutral = 0.5
        case content = 0.75
        case happy = 1.0
    }
    static let sentimentsArray = ["crying", "sad", "neutral", "content", "happy"]
    static let sentimentColors = [Color.red, Color.orange, Color.blue, Color.green.adjust(brightness: 0.1), Color.green.adjust(brightness: -0.1)]
    
    static let timeIntervals = ["Day", "Week", "Month", "Year"]
    
    static let defaultActivities =
    (["Friends", "Hobby", "Meal", "Mindfulness", "Relax", "Shopping", "Sleep", "Sport", "Walk", "Work"],
     ["person.3.fill", "pianokeys", "fork.knife", "brain.head.profile", "leaf.fill", "takeoutbag.and.cup.and.straw.fill", "bed.double.fill", "bicycle", "figure.walk", "briefcase.fill"])
}
