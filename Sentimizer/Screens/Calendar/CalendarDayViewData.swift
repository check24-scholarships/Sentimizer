//
//  CalendarDayViewData.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import SwiftUI

extension CalendarDayDetailView {
    func getHours(content: [ActivityData]) -> [Int] {
        if content.count > 0 {
            let firstHour = Calendar.current.component(.hour, from: content[0].date)
            let lastHour = Calendar.current.component(.hour, from: content[content.count-1].date)
            
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
    
    func getDataForSection(content: [ActivityData], _ timeSection: String) -> [ActivityData] {
        var newData: [ActivityData] = []
        for d in content {
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
