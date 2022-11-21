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
        case settings
    }
    
    @State private var selection: Tab = .activities

    var body: some View {
        TabView(selection: $selection) {
            MainTab()
            .tag(Tab.activities)
            .toolbarBackground(.visible, for: .tabBar)
            
            StatsTab()
            .tag(Tab.stats)
            .toolbarBackground(.visible, for: .tabBar)
            
            CalendarTab()
            .tag(Tab.calendar)
            .toolbarBackground(.visible, for: .tabBar)
            
            SettingsTab()
            .tag(Tab.settings)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "ArialRoundedMTBold", size: 35)!, .foregroundColor : UIColor(named: "textColor") ?? .label]
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "ArialRoundedMTBold", size: 19)!, .foregroundColor : UIColor(named: "textColor") ?? .label]
        UINavigationBar.appearance().barTintColor = UIColor(named: "bgColor")
        UITabBar.appearance().barTintColor = UIColor(named: "tabBarColor")
        UITabBar.appearance().unselectedItemTintColor = .gray.withAlphaComponent(0.7)
    }
}

struct MainTab: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.bgColor.ignoresSafeArea()
                MainActivityView()
                    .foregroundColor(.textColor)
                    .navigationTitle("Activities")
            }
        }
        .tabItem {
            let activitiesText = Text("Activities", comment: "Activity main tab title")
            Label {
                activitiesText
            } icon: {
                Image(systemName: "list.bullet.below.rectangle")
            }
            .accessibility(label: activitiesText)
        }
    }
}

struct StatsTab: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.bgColor.ignoresSafeArea()
                StatsView()
                    .foregroundColor(.textColor)
                    .navigationTitle("Statistics")
            }
        }
        .tabItem {
            let statsText = Text("Statistics", comment: "Statistics tab title")
            Label {
                statsText
            } icon: {
                Image(systemName: "chart.bar.fill")
            }
            .accessibility(label: statsText)
        }
    }
}

struct CalendarTab: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.bgColor.ignoresSafeArea()
                CalendarView()
                    .foregroundColor(.textColor)
                    .navigationTitle("Calendar")
            }
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
    }
}

struct SettingsTab: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.bgColor.ignoresSafeArea()
                SettingsView()
                    .foregroundColor(.textColor)
                    .navigationTitle("Settings")
            }
        }
        .tabItem {
            let settingsText = Text("Settings", comment: "Settings tab title")
            Label {
                settingsText
            } icon: {
                Image(systemName: "gearshape.fill")
            }
            .accessibility(label: settingsText)
        }
    }
}

struct AppTabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}
