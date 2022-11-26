//
//  WhatNext.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 08.05.22.
//

import SwiftUI

struct WhatNext: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var activity = ""
    var backgroundGray = false
    
    @State private var brandColor2 = Color.brandColor2
    @State private var brandColor2Light = Color.brandColor2Light
    
    @Binding var addSheetPresented: Bool
    @Binding var activityToAdd: String
    
    var body: some View {
        VStack {
            Text("What should I do next?")
                .font(.senti(size: 23))
                .fontWeight(.semibold)
                .gradientForeground(colors: [brandColor2, brandColor2Light])
            Text("Sentimizer recommends this activity:")
                .font(.senti(size: 15))
                .fontWeight(.semibold)
                .opacity(0.7)
            SentiButton(icon: PersistenceController().getActivityIcon(activityName: activity, viewContext), title: LocalizedStringKey(activity), style: .outlined, chevron: false, shadow: false)
                .gradientForeground(colors: [brandColor2, brandColor2Light])
                .scaleEffect(0.8)
                .onTapGesture {
                    activityToAdd = activity
                    addSheetPresented = true
                }
        }
        .padding()
        .if(backgroundGray) { view in
            view.standardBackground()
        } else: { view in
            view.background(RoundedRectangle(cornerRadius: 25).foregroundColor(.dayViewBgColor).opacity(0.8))
        }
        .onAppear {
            brandColor2 = Color.brandColor2
            brandColor2Light = Color.brandColor2Light
            activity = Model().influenceImprovedYear.0.first ?? "Walk"
        }
    }
}

struct WhatNext_Previews: PreviewProvider {
    static var previews: some View {
        WhatNext(addSheetPresented: .constant(false), activityToAdd: .constant(""))
    }
}
