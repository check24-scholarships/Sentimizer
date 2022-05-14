//
//  ActivityDetailView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 13.05.22.
//

import SwiftUI
import CoreData

struct ActivityDetailView: View {
    let activity: String
    let icon: String
    let description: String
    let day: String
    let time: String
    let duration: String
    let sentiment: String
    let id: String
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State var isPresentingConfirm = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(time)
                    .font(.senti(size: 23))
                    .padding(.leading, 25)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("ACTIVITY")
                            .font(.senti(size: 12))
                        Spacer()
                    }
                        
                    HStack {
                        Image(systemName: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 45, maxHeight: 45)
                        Text(activity)
                            .font(.senti(size: 30))
                    }
                    .padding(.bottom)
                    .gradientForeground()
                    
                    Text("MOOD")
                        .font(.senti(size: 12))
                        .padding(.top, 5)
                    
                    let sentiIndex = K.sentimentsArray.firstIndex(of: sentiment)
                    Image(K.sentimentsArray[sentiIndex ?? 0])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 55)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(K.sentimentColors[sentiIndex ?? 0].opacity(0.2)))
                        .padding(.top, 5)
                        .padding(.bottom)
                    
                    Text("DESCRIPTION")
                        .font(.senti(size: 12))
                        .padding(.top, 5)
                        .lineLimit(15)
                    
                    Text(description.isEmpty ? "Describe your activity..." : description)
                        .font(.senti(size: 18))
                        .padding(.bottom)
                }
                .padding()
                .standardBackground()
                .padding(.horizontal, 15)
                
                Button {
                    isPresentingConfirm = true
                } label: {
                    Text("Delete this activity")
                        .font(.senti(size: 20))
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 25).foregroundColor(K.brandColor1).opacity(0.1))
                        .padding()
                        .padding(.top)
                }
            }
        }
        .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
            Button("Delete activity", role: .destructive) {
                deleteActivity(moc: viewContext)
                dismiss()
            }
        } message: {
            Text("You cannot undo this action.")
        }
        .navigationTitle(day)
    }
    
    func deleteActivity(moc: NSManagedObjectContext) {
        let objectID = moc.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: URL(string: id)!)!
        
        let object = try! moc.existingObject(with: objectID)
        
        moc.delete(object)
        
        do {
            try moc.save()
        } catch {
            print("In \(#function), line \(#line), save activity failed:")
            print(error.localizedDescription)
        }
    }}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activity: "Walking", icon: "figure.walk", description: "helllooooo", day: "Today", time: "08:15", duration: "10 min", sentiment: "happy", id: "")
    }
}
