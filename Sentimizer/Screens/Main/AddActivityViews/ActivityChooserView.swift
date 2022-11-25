//
//  ActivityChooserView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, 2022.
//

import SwiftUI
import CoreData

struct ActivityChooserView: View {
    
    @Binding var activity: String
    @Binding var icon: String
    var redirectToEdit: Bool = false
    
    @FetchRequest private var activities: FetchedResults<Activity>
    
    var body: some View {
        ScrollView {
            VStack {
                ViewTitle("Choose your category", fontSize: 30)
                    .frame(maxWidth: .infinity)
                
                if redirectToEdit && activities.count < 1 {
                    NoCustomCategories()
                }
                
                if !redirectToEdit {
                    DefaultActivities(activity: $activity, icon: $icon)
                }
                
                ForEach(0 ..< activities.count, id: \.self) { i in
                    if redirectToEdit {
                        NavigationLink {
                            EditActivityCategoryView(activityName: activities[i].name ?? K.unspecified, icon: activities[i].icon ?? K.unspecifiedSymbol)
                        } label: {
                            SentiButton(icon: activities[i].icon ?? K.unspecifiedSymbol, title: LocalizedStringKey(activities[i].name ?? K.unspecified))
                        }
                    } else {
                        CustomActivityButton(activity: activities[i], chosenActivity: $activity, chosenIcon: $icon)
                    }
                }
                
                NewCategoryLink()
            }
            .padding()
        }
    }
    
    init(activity: Binding<String>, icon: Binding<String>, redirectToEdit: Bool = false) {
        let f: NSFetchRequest<Activity> = Activity.fetchRequest()
        f.sortDescriptors = []
        _activities = FetchRequest(fetchRequest: f)
        
        self._activity = activity
        self._icon = icon
        self.redirectToEdit = redirectToEdit
    }
}

struct NoCustomCategories: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "figure.walk")
                Image(systemName: "fork.knife")
                Image(systemName: "briefcase.fill")
            }
            .font(.title2)
            Text("There are no custom categories yet.")
                .font(.sentiBold(size: 15))
                .bold()
                .padding()
        }
        .padding(.top, 30)
    }
}

struct DefaultActivities: View {
    @Binding var activity: String
    @Binding var icon: String
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ForEach(0 ..< K.defaultActivities.0.count, id: \.self) { i in
            Button {
                activity = K.defaultActivities.0[i]
                icon = K.defaultActivities.1[i]
                dismiss()
            } label: {
                SentiButton(icon: K.defaultActivities.1[i], title: LocalizedStringKey(K.defaultActivities.0[i]))
            }
        }
    }
}

struct CustomActivityButton: View {
    let activity: Activity
    @Binding var chosenActivity: String
    @Binding var chosenIcon: String
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            chosenActivity = activity.name ?? K.unspecified
            chosenIcon = activity.icon ?? K.unspecifiedSymbol
            dismiss()
        } label: {
            SentiButton(icon: activity.icon ?? K.unspecifiedSymbol, title: LocalizedStringKey(activity.name ?? K.unspecified))
        }
    }
}

struct NewCategoryLink: View {
    var body: some View {
        NavigationLink {
            ZStack {
                Color.bgColor.ignoresSafeArea()
                NewActivityCategoryView()
            }
        } label: {
            SentiButton(icon: "plus.circle", title: "New category", style: .outlined, fontSize: 20, textColor: .gray)
                .padding()
                .padding(.top)
        }
    }
}

struct ActivityChooser_Previews: PreviewProvider {
    static var previews: some View {
        ActivityChooserView(activity: .constant(""), icon: .constant(""))
    }
}
