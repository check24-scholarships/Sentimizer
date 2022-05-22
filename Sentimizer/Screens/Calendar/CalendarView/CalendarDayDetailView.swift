//
//  CalendarDayDetailView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 18.05.22.
//

import SwiftUI

struct CalendarDayDetailView: View {
    let data: [CalendarModel]
    let date: Date
    
    @StateObject private var dataController = DataController()
    
    var hours: [String] {
        var hours: [String] = []
        for hour in 0...23 {
            hours.append("\(hour):00")
        }
        
        return hours
    }
    
    var day: String {
        return "\(DateFormatter.formatDate(date: date, format: "EE")), \(DateFormatter.formatDate(date: date, format: "d. MMM"))"
    }
    
    var body: some View {
        ScrollView {
            ViewTitle(day)
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(K.timeSections, id: \.self) { timeSection in
                    
                    if getDataForSection(timeSection).count > 0 {
                        getTitleForSection(timeSection)
                            .font(.senti(size: 20))
                            .gradientForeground()
                    }
                    
                    ForEach(getDataForSection(timeSection), id: \.self) { activity in
                        ActivityBar(activity: "Walk", description: "", time: (DateFormatter.formatDate(date: Date(), format: "HH:mm"), "10"), sentiment: "happy", id: "1", icon: "figure.walk")
                            .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.gray).opacity(0.2))
                            .shadow(radius: 10)
                    }
                }
                
                
                
                    .padding(.top)
            }
            .padding(.horizontal, 15)
        }
    }
}

struct CalendarDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDayDetailView(data: [CalendarModel(date: Date(), activity: "Walk", icon: "figure.walk"), CalendarModel(date: Date(), activity: "Walk", icon: "figure.walk")], date: Date())
    }
}
