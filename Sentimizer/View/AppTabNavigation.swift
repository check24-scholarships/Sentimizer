//
//  AppTabNavigation.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, 2022.
//

import SwiftUI

struct AppTabNavigation: View {
    
    enum Tab {
        case activities
        case stats
        case calendar
    }

    @State private var selection: Tab = .activities

    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                MainActivityView()
            }
            .tabItem {
                let activitiesText = Text("Activities", comment: "Activity main tab title")
                Label {
                    activitiesText
                } icon: {
                    Image(systemName: "house")
                }
                .accessibility(label: activitiesText)
            }
            .tag(Tab.activities)
            
            NavigationView {
                StatsView()
            }
            .tabItem {
                let statsText = Text("Statistics", comment: "Statistics tab title")
                Label {
                    statsText
                } icon: {
                    Image(systemName: "chart.xyaxis.line")
                }
                .accessibility(label: statsText)
            }
            .tag(Tab.stats)
            
            NavigationView {
                MainActivityView()
            }
            .tabItem {
                let calendarText = Text("Calendar", comment: "Calendar tab title")
                Label {
                    calendarText
                } icon: {
                    Image(systemName: "calendar")
                }
                .accessibility(label: calendarText)
            }
            .tag(Tab.calendar)
        }
    }
}

struct AppTabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}
