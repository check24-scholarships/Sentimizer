//
//  CalendarView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 26.04.22.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        VStack {
            WeekDays()
                .padding(5)
            
            ScrollView {
                DateCalendar()
            }
        }
        .navigationTitle("Calendar")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                VStack {
                    Button  {
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

//MARK: - Calendar Bar
struct WeekDays: View {
    let weekDays = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        HStack {
            ForEach(0..<7, id: \.self) { index in
                Spacer()
                Text(weekDays[index])
                    .bold()
                    .padding(9)
                    .foregroundColor(.white)
                    .font(.senti(size: 25))
                Spacer()
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(K.brandColor2)
                .shadow(radius: 10)
        }
    }
}

//MARK: - Calendar
struct DateCalendar: View {
    var body: some View {
        VStack {
            MonthItem(monthName: "Mai")
        }
    }
}

//MARK: - Month Item
struct MonthItem: View{
    
    let getter = MonthGetter()
    let week = 2
    let monthName: String
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                
                VStack {
                    ForEach(0..<(Int(getter.monthDayNumber/7 + 1))) { week in
                        HStack {
                            ForEach(1..<8) { day in
                                if getter.firstWeekday > day+week*7 || day+week*7-getter.firstWeekday+1 > getter.monthDayNumber {
                                    Spacer()
                                        .frame(width: geo.size.width/7)
                                } else {
                                    DayItem(day+week*7-getter.firstWeekday+1)
                                }
                            }
                        }   .frame(height: 80)
                    }
                }
                .padding(.trailing)
            }
        }
    }
}

//MARK: - Day Item
struct DayItem: View {
    
    let dayNumber: Int
    
    init(_ number: Int) {
        dayNumber = number
    }
    
    var body: some View {
        Button {
            
        } label: {
            VStack{
                HStack{
                    Spacer()
                    Text(String(dayNumber))
                        .font(.system(size: 18))
                }
                Spacer()
            }
        }
    }
}

//MARK: - MonthGetter
struct MonthGetter {
    let monthDayNumber = 31
    let dateFormatter = DateFormatter()
    let now = Date()
    let firstWeekday = 2
    let monthName = "Mai"
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
