//
//  String+Extension.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 07.07.22.
//

import Foundation

extension String {
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
