//
//  CalendarDayDetailView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 18.05.22.
//

import SwiftUI

struct CalendarDayDetailView: View {
    let data: [CalendarData]

    var body: some View {
        Text(data[0].activity)
    }
}

struct CalendarDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDayDetailView(data: [CalendarData(date: Date(), activity: "Walk", icon: "figure.walk")])
    }
}
