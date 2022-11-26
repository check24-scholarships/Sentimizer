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
        return .custom("Resources/Poppins-Regular", size:size)
    }
    // Old: Helvetica Neue Bold, Helvetica Neue, Helvetica Neue Medium
}

