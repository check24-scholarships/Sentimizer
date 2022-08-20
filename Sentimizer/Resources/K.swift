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
    
    
    //MARK: - UserDefaults
    static let modelURL = "modelURL"
    static let torchURL = "torchURL"
    
    enum AppColorScheme: String {
        case light = "light"
        case dark = "dark"
        case auto = "auto"
    }
    static let colorSchemeURL = "colorScheme"
    static let colorTheme = "colorTheme"
    
    static let monthInfluence = "monthInfluence"
    static let yearInfluence = "yearInfluence"
    
    static let userNickname = "nickname"
    static let welcomeScreenShown = "welcomeScreenShown"
    
    static let appHasToBeUnlocked = "appHasToBeUnlocked"
    
    static let userId = "userId"
    
    //MARK: - Other
    
    static let mail = "samuel.ginsberg@t-online.de"
    
    enum timeOfDay {
        case morning
        case afternoon
        case evening
    }
    
    static func stringForTimeOfDay(_ timeOfDay: K.timeOfDay) -> String {
        switch timeOfDay {
        case .morning:
            return String(localized: "Morning")
        case .afternoon:
            return String(localized: "Afternoon")
        case .evening:
            return String(localized: "Evening")
        }
    }
    
    static func symbolForTimeOfDay(_ timeOfDay: K.timeOfDay) -> String {
        switch timeOfDay {
        case .morning:
            return "sunrise.fill"
        case .afternoon:
            return "sun.max"
        case .evening:
            return "moon.stars.fill"
        }
    }
    
    static let unspecified = "Unspecified"
    static let unspecifiedSymbol = "camera.metering.unknown"
    
    // ML
    
    static let serverURL = "http://127.0.0.1:8000/"
    
    static var rnn = RNN(inN: 1, hsN: 1)
    
    
    
    //MARK: - Activities and icons
    
    static let defaultActivities =
    (["Friends", "Hobby", "Meal", "Mindfulness", "Relax", "Shopping", "Sleep", "Sport", "Walk", "Work", "Unspecified"],
     ["person.3.fill", "pianokeys", "fork.knife", "brain.head.profile", "leaf.fill", "takeoutbag.and.cup.and.straw.fill", "bed.double.fill", "bicycle", "figure.walk", "briefcase.fill", "camera.metering.unknown"])
    
    static let defaultIcons =
    [("People", ["person.fill", "person.fill.viewfinder", "person.2.fill", "person.3.fill", "eyes.inverse", "mouth", "mustache.fill", "ear.fill", "hand.raised.fill", "rectangle.and.hand.point.up.left.fill", "hand.point.left.fill", "hands.clap.fill", "heart.fill", "brain.head.profile", "brain", "lungs.fill", "figure.walk", "figure.stand", "bubble.left.fill", "phone.fill"]), ("Nature", ["globe.americas.fill", "sun.max.fill", "moon.fill", "sparkles", "cloud.fill", "snowflake", "bolt.fill", "hare.fill", "tortoise.fill", "pawprint.fill", "leaf.fill"]), ("Objects", ["pencil", "trash.fill", "paperplane.fill", "archivebox.fill", "book.closed.fill", "books.vertical.fill", "graduationcap.fill", "paperclip", "megaphone.fill", "music.mic", "guitars.fill", "pianokeys.inverse", "theatermasks.fill", "flag.fill", "flag.filled.and.flag.crossed", "bell.fill", "tag.fill", "eyeglasses", "camera.fill", "die.face.6.fill",  "paintbrush.fill", "hammer.fill", "briefcase.fill", "suitcase.fill", "bed.double.fill", "film.fill", "gamecontroller.fill", "cup.and.saucer.fill", "takeoutbag.and.cup.and.straw.fill", "fork.knife", "keyboard.fill", "tv.fill", "platter.filled.bottom.iphone", "computermouse.fill", "headphones"]), ("Transport", ["airplane", "car.fill", "bus", "ferry.fill", "bicycle"])]
    
    static let allIcons =
    ["mic.fill", "mic.slash.fill", "mic.fill.badge.plus", "star.bubble.fill", "character.bubble.fill", "text.bubble.fill", "captions.bubble.fill", "plus.bubble.fill", "checkmark.bubble.fill", "rectangle.3.group.bubble.left.fill", "ellipsis.bubble.fill", "phone.bubble.left.fill", "bubble.middle.bottom.fill", "bubble.left.and.bubble.right.fill", "phone.fill", "phone.fill.arrow.down.left", "phone.fill.arrow.right", "phone.down.fill", "envelope.fill", "envelope.open.fill", "waveform", "sun.min.fill", "sun.max.fill", "sunrise.fill", "sunset.fill", "sun.and.horizon.fill", "sun.dust.fill", "sun.haze.fill", "moon.fill", "sparkles", "cloud.fill", "cloud.drizzle.fill", "cloud.rain.fill", "cloud.heavyrain.fill", "cloud.fog.fill", "cloud.hail.fill", "cloud.snow.fill", "cloud.sleet.fill", "cloud.bolt.fill", "cloud.bolt.rain.fill", "cloud.sun.fill", "cloud.sun.rain.fill", "cloud.sun.bolt.fill", "cloud.moon.fill", "smoke.fill", "hurricane", "thermometer.sun", "thermometer.sun.fill", "thermometer.snowflake", "thermometer", "aqi.medium", "humidity.fill", "pencil", "pencil.slash", "square.and.pencil", "rectangle.and.pencil.and.ellipsis", "highlighter", "pencil.and.outline", "lasso", "trash.fill", "folder.fill", "paperplane.fill", "tray.fill", "tray.2.fill", "externaldrive.fill", "archivebox.fill", "doc.fill", "note.text", "calendar", "book.fill", "books.vertical.fill", "book.closed.fill", "magazine.fill", "newspaper.fill", "bookmark.fill", "graduationcap.fill", "paperclip", "link", "speaker.wave.2.fill", "music.mic", "magnifyingglass", "flag.fill", "flag.2.crossed.fill", "bell.fill", "bell.badge.fill", "tag.fill", "bolt.shield.fill", "eyeglasses", "facemask.fill", "flashlight.on.fill", "camera.fill", "camera.shutter.button.fill", "gearshape.fill", "scissors", "wand.and.rays", "wand.and.stars", "dial.max.fill", "speedometer", "barometer", "metronome.fill", "dice.fill", "die.face.6.fill", "pianokeys.inverse", "tuningfork", "paintbrush.fill", "paintbrush.pointed.fill", "camera.filters", "bandage.fill", "ruler.fill", "level.fill", "hammer.fill", "wrench.and.screwdriver.fill", "printer.dotmatrix.fill", "scanner.fill", "briefcase.fill", "case.fill", "suitcase.fill", "theatermasks.fill", "puzzlepiece.extension.fill", "building.fill", "building.2.fill", "lock.fill", "lock.open.fill", "key.fill", "pin.fill", "mappin.and.ellipse", "map.fill", "powerplug.fill", "cpu.fill", "headphones", "guitars.fill", "fuelpump.fill", "fanblades.fill", "bed.double.fill", "testtube.2", "cross.vial.fill", "film.fill", "crown.fill", "comb.fill", "shield.fill", "cube.fill", "stopwatch.fill", "chart.xyaxis.line", "gamecontroller.fill", "paintpalette.fill", "cup.and.saucer.fill", "takeoutbag.and.cup.and.straw.fill", "cart.fill", "creditcard.fill", "banknote.fill", "fork.knife", "gift.fill", "studentdesk", "clock.fill", "alarm.fill", "hourglass", "lifepreserver.fill", "binoculars.fill", "lightbulb.fill", "airplane", "airplane.departure", "car.fill", "car.2.fill", "bus", "tram.fill", "cablecar.fill", "ferry.fill", "train.side.front.car", "bicycle", "scooter", "figure.walk", "figure.wave", "person.fill", "person.2.fill", "person.3.sequence.fill", "person.crop.circle.fill", "eye.fill", "tshirt.fill", "eyebrow", "nose.fill", "mustache.fill", "mouth.fill", "brain.head.profile", "lungs.fill", "figure.roll", "ear.fill", "hand.raised.fill", "hand.point.up.left.fill", "hand.wave.fill", "hands.clap.fill", "hands.sparkles.fill", "globe.europe.africa.fill", "flame.fill", "drop.fill", "bolt.fill", "allergens", "hare.fill", "tortoise.fill", "pawprint.fill", "ant.fill", "leaf.fill", "play.fill", "pause.fill", "stop.fill", "playpause.fill", "backward.fill", "forward.fill", "command.circle.fill", "delete.left.fill", "shift.fill", "power", "minus.forwardslash.plus", "x.squareroot"]

}
