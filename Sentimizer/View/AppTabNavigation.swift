//
//  AppTabNavigation.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, 2022.
//

import SwiftUI

struct AppTabNavigation: View {
    
    let tabs = ["list.bullet.below.rectangle", "chart.bar.fill", "calendar"]
    
    @State private var selection: String = "list.bullet.below.rectangle"
    @Environment(\.managedObjectContext) var moc

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                NavigationView {
                    ZStack {
                        K.bgColor.ignoresSafeArea()
                        MainActivityView()
                            .foregroundColor(K.textColor)
                            .navigationTitle("Activities")
                    }
                }
                .tag(tabs[0])
                
                NavigationView {
                    ZStack {
                        K.bgColor.ignoresSafeArea()
                        StatsView()
                            .foregroundColor(K.textColor)
                            .navigationTitle("Statistics")
                    }
                }
                .tag(tabs[1])
                
                NavigationView {
                    ZStack {
                        K.bgColor.ignoresSafeArea()
                        MainActivityView()
                            .foregroundColor(K.textColor)
                            .navigationTitle("Calendar")
                    }
                }
                .tag(tabs[2])
            }
            
            VStack {
                Spacer()
                
                HStack {
                    ForEach(tabs, id: \.self) { tab in
                        Button {
                            selection = tab
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: tab)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 30, maxHeight: 30)
                                    .padding(12)
                                    .foregroundColor(selection == tab ? K.brandColor2 : .gray)
//                                    .background(selection == tab ? RoundedRectangle(cornerRadius: 15).foregroundColor(.gray).opacity(0.2) : nil)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 50).foregroundColor(K.bgColor).shadow(radius: 10))
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(.gray, lineWidth: 1)
                )
                .padding(.horizontal)
            }
        }
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "ArialRoundedMTBold", size: 35)!, .foregroundColor : UIColor(named: "textColor") ?? .label]
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "ArialRoundedMTBold", size: 19)!, .foregroundColor : UIColor(named: "textColor") ?? .label]
        UINavigationBar.appearance().barTintColor = UIColor(named: "bgColor")
        UITabBar.appearance().isHidden = true
    }
}

struct AppTabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}
