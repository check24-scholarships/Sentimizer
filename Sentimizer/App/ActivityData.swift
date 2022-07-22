//
//  ActivityData.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 25.05.22.
//

import Foundation
import SwiftUI

struct ActivityData: Hashable, Codable {
    let id: String
    let activity: String
    let icon: String
    let date: Date
    let description: String
    let sentiment: String
}
