//
//  CalendarDayDetailView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 18.05.22.
//

import SwiftUI

struct CalendarDayDetailView: View {
    let data: [CalendarData]
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
        return "\(dataController.formatDate(date: date, format: "EE")), \(dataController.formatDate(date: date, format: "d. MMM"))"
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
                        ActivityBar(activity: "Walk", description: "", time: (dataController.formatDate(date: Date(), format: "HH:mm"), "10"), sentiment: "happy", id: "1", icon: "figure.walk")
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
    
    func getTitleForSection(_ timeSection: String) -> Text {
        switch timeSection {
        case K.timeSections[0]:
            return Text("\(Image(systemName: "sunrise.fill")) 00:00 - 10:00")
        case K.timeSections[1]:
            return Text("\(Image(systemName: "sun.max.fill")) 10:00 - 13:00")
        case K.timeSections[2]:
            return Text("\(Image(systemName: "sun.min.fill")) 13:00 - 17:00")
        case K.timeSections[3]:
            return Text("\(Image(systemName: "sunset.fill")) 17:00 - 24:00")
        default:
            return Text("\(Image(systemName: "sunrise.fill")) 00:00 - 10:00")
        }
    }
    
    func getDataForSection(_ timeSection: String) -> [CalendarData] {
        var newData: [CalendarData] = []
        for d in data {
            let hour = Calendar.current.component(.hour, from: d.date)
            
            switch timeSection {
            case K.timeSections[0]:
                if hour < 10 {
                    newData.append(d)
                }
            case K.timeSections[1]:
                if hour > 9 && hour < 13 {
                    newData.append(d)
                }
            case K.timeSections[2]:
                if hour > 12 && hour < 17 {
                    newData.append(d)
                }
            case K.timeSections[3]:
                if hour > 16 {
                    newData.append(d)
                }
            default: print("Something weird happened in function \(#function), line \(#line)")
            }
        }
        
        return newData
    }
}

struct CalendarDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDayDetailView(data: [CalendarData(date: Date(), activity: "Walk", icon: "figure.walk"), CalendarData(date: Date(), activity: "Walk", icon: "figure.walk")], date: Date())
    }
}
