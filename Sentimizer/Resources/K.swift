//
//  K.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, Justin Hohenstein, Henry Pham, 2022.
//

import SwiftUI

struct K {
    //MARK: - Sentiments
    
    enum Sentiments: Double {
        case crying = 0.0
        case sad = 0.25
        case neutral = 0.5
        case content = 0.75
        case happy = 1.0
    }
    static let sentimentsArray = ["crying", "sad", "neutral", "content", "happy"]
    static let sentimentColors = [Color.red, Color.orange, Color.yellow, Color.green.adjust(brightness: 0.1), Color.green.adjust(brightness: -0.1)]
    
    static let timeIntervals = ["Day", "Week", "Month", "Year"]
    
    static let timeSections = ["Morning", "PrenoonNoon", "Afternoon", "Evening"]
    
    //MARK: - Activities and icons
    
    static let defaultActivities =
    (["Friends", "Hobby", "Meal", "Mindfulness", "Relax", "Shopping", "Sleep", "Sport", "Walk", "Work", "Unspecified"],
     ["person.3.fill", "pianokeys", "fork.knife", "brain.head.profile", "leaf.fill", "takeoutbag.and.cup.and.straw.fill", "bed.double.fill", "bicycle", "figure.walk", "briefcase.fill", "camera.metering.unknown"])
    
    static let defaultIcons =
    [("People", ["person.fill", "person.fill.viewfinder", "person.2.fill", "person.3.fill", "eyes.inverse", "mouth", "mustache.fill", "ear.fill", "hand.raised.fill", "rectangle.and.hand.point.up.left.fill", "hand.point.left.fill", "hands.clap.fill", "heart.fill", "brain.head.profile", "brain", "lungs.fill", "figure.walk", "figure.stand", "bubble.left.fill", "phone.fill"]), ("Nature", ["globe.americas.fill", "sun.max.fill", "moon.fill", "sparkles", "cloud.fill", "snowflake", "bolt.fill", "hare.fill", "tortoise.fill", "pawprint.fill", "leaf.fill"]), ("Objects", ["pencil", "trash.fill", "paperplane.fill", "archivebox.fill", "book.closed.fill", "books.vertical.fill", "graduationcap.fill", "paperclip", "megaphone.fill", "music.mic", "guitars.fill", "pianokeys.inverse", "theatermasks.fill", "flag.fill", "flag.filled.and.flag.crossed", "bell.fill", "tag.fill", "eyeglasses", "camera.fill", "die.face.6.fill",  "paintbrush.fill", "hammer.fill", "briefcase.fill", "suitcase.fill", "bed.double.fill", "film.fill", "gamecontroller.fill", "cup.and.saucer.fill", "takeoutbag.and.cup.and.straw.fill", "fork.knife", "keyboard.fill", "tv.fill", "platter.filled.bottom.iphone", "computermouse.fill", "headphones"]), ("Transport", ["airplane", "car.fill", "bus", "ferry.fill", "bicycle"])]
    
    
    //MARK: - UserDefaults
    static let modelURL = "modelURL"
    enum AppColorScheme: String {
        case light = "light"
        case dark = "dark"
        case auto = "auto"
    }
    static let colorSchemeURL = "colorScheme"
    
    static let monthInfluence = "monthInfluence"
    static let yearInfluence = "yearInfluence"
    
    static let userNickname = "nickname"
    static let welcomeScreenShown = "welcomeScreenShown"
}
