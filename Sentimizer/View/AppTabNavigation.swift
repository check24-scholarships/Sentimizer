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
    @Environment(\.managedObjectContext) var moc

    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                ZStack {
                    K.bgColor.ignoresSafeArea()
                    MainActivityView()
                        .foregroundColor(K.textColor)
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
            .tag(Tab.activities)
            
            NavigationView {
                ZStack {
                    K.bgColor.ignoresSafeArea()
                    StatsView()
                        .foregroundColor(K.textColor)
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
            .tag(Tab.stats)
            
            NavigationView {
                ZStack {
                    K.bgColor.ignoresSafeArea()
                    MainActivityView()
                        .foregroundColor(K.textColor)
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
            .tag(Tab.calendar)
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

struct AppTabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}
