//
//  CalendarDayDetailView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 18.05.22.
//

import SwiftUI

struct CalendarDayDetailView: View {
    let data: [CalendarData]
    
    @StateObject private var dataController = DataController()
    
    var hours: [String] {
        var hours: [String] = []
        for hour in 0...23 {
            hours.append("\(hour):00")
        }
        
        return hours
    }
    
    var day: String {
        return "\(dataController.formatDate(date: data[0].date, format: "EE")), \(dataController.formatDate(date: data[0].date, format: "d. MMM"))"
    }
    
    var body: some View {
        ScrollView {
            ViewTitle(day)
            
            VStack(alignment: .leading) {
                Image(systemName: "sun.and.horizon.fill")
                
                
                
                    .padding(.top)
            }
        }
    }
}

extension CalendarDayDetailView {
    func getHours() -> [Int] {
        if data.count > 0 {
            let firstHour = Calendar.current.component(.hour, from: data[0].date)
            let lastHour = Calendar.current.component(.hour, from: data[data.count-1].date)
            
            var hours: [Int] = []
            for i in firstHour...lastHour {
                hours.append(i)
            }
            
            return hours
        }
        return []
    }
}

struct CalendarDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDayDetailView(data: [CalendarData(date: Date(), activity: "Walk", icon: "figure.walk")])
    }
}
