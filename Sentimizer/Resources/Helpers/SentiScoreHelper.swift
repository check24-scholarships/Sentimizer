//
//  SentiScoreHelper.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import Foundation

struct SentiScoreHelper {
    static func getSentiScore(for sentiment: String) -> Double {
        switch sentiment {
        case "crying":
            return 0
        case "sad":
            return 0.25
        case "neutral":
            return 0.5
        case "content":
            return 0.75
        case "happy":
            return 1
        default:
            return 0.5
        }
    }
    
    static func getSentiIndex(for sentiment: String) -> Int {
        switch sentiment {
        case "crying":
            return 0
        case "sad":
            return 1
        case "neutral":
            return 2
        case "content":
            return 3
        case "happy":
            return 4
        default:
            return 0
        }
    }
}
