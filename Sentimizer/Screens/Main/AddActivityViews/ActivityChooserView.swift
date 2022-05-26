//
//  ActivityChooserView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, 2022.
//

import SwiftUI

struct ActivityChooserView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var activity: String
    @Binding var icon: String
    var redirectToEdit: Bool = false
    
    @FetchRequest(entity: Activity.entity(), sortDescriptors: []) var activities: FetchedResults<Activity>
    
    var body: some View {
        ScrollView {
            VStack {
                ViewTitle("Choose your category", fontSize: 30)
                    .frame(maxWidth: .infinity)
                
                
                if !redirectToEdit {
                    ForEach(0 ..< K.defaultActivities.0.count, id: \.self) { i in
                        Button {
                            activity = K.defaultActivities.0[i]
                            icon = K.defaultActivities.1[i]
                            dismiss()
                        } label: {
                            SentiButton(icon: K.defaultActivities.1[i], title: K.defaultActivities.0[i])
                        }
                    }
                }
                
                ForEach(0 ..< activities.count, id: \.self) { i in
                    if redirectToEdit {
                        NavigationLink {
                            EditActivityCategoryView(activityName: activities[i].name!, icon: activities[i].icon!)
                        } label: {
                            SentiButton(icon: activities[i].icon!, title: activities[i].name!)
                        }
                    } else {
                        Button {
                            activity = activities[i].name!
                            icon = activities[i].icon!
                            dismiss()
                        } label: {
                            SentiButton(icon: activities[i].icon!, title: activities[i].name!)
                        }
                    }
                }
                
                NavigationLink {
                    ZStack {
                        Color.bgColor.ignoresSafeArea()
                        NewActivityCategoryView()
                    }
                } label: {
                    SentiButton(icon: "plus.circle", title: "Add new category", style: .outlined, fontSize: 20, textColor: .gray)
                        .padding()
                        .padding(.top)
                }
            }
            .padding()
        }
    }
}

struct ActivityChooser_Previews: PreviewProvider {
    static var previews: some View {
        ActivityChooserView(activity: .constant(""), icon: .constant(""))
    }
}
