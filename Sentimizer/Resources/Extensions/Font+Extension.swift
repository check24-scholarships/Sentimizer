//
//  Font+Extension.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, 2022.
//

import SwiftUI

extension Font {
    /// The custom Sentimizer font.
    ///  - parameter size: Preferred font size.
    ///  - returns: The custom font.
    static func senti(size: CGFloat) -> Font {
        return .custom("ArialRoundedMTBold", size: size)
    }
    
    static func sentiLight(size: CGFloat) -> Font {
        // return .custom("Helvetica Light", size:size)
        return .custom("Helvetica Neue", size:size)
    }
}

