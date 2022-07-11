//
//  Model.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 11.07.22.
//

import Foundation

class Model: ObservableObject {
    @Published var influenceImprovedMonth: ([String], [Double]) = ([], [])
    @Published var influenceImprovedYear: ([String], [Double]) = ([], [])
    @Published var influenceWorsenedMonth: ([String], [Double]) = ([], [])
    @Published var influenceWorsenedYear: ([String], [Double]) = ([], [])
    
    init() {
        let influenceMonth = PersistenceController.getInfluence(with: K.monthInfluence)
        let influenceYear = PersistenceController.getInfluence(with: K.yearInfluence)
        
        influenceImprovedMonth = influenceMonth.0
        influenceWorsenedMonth = influenceMonth.1
        influenceImprovedYear = influenceYear.0
        influenceWorsenedYear = influenceYear.1
    }
}
