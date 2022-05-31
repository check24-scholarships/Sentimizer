//
//  InfluenceData.swift
//  Sentimizer
//
//  Created by Justin Hohenstein on 31.05.22.
//

import Foundation

struct InfluenceData: Codable {
    let improvedName: [String]
    let improvedValue: [Double]
    let worsenedName: [String]
    let worsenedValue: [Double]
}
