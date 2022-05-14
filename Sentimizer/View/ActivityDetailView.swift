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
    @State var description: String
    let day: String
    let time: String
    let duration: String
    let sentiment: String
    let id: String
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State var isEditingDescription = false
    @State var isPresentingConfirm = false
    
    var body: some View {
        ScrollViewReader { scrollView in
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
                        
                        let sentiIndex = K.sentimentsArray.firstIndex(of: sentiment) ?? 0
                        Image(K.sentimentsArray[sentiIndex])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 55)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(K.sentimentColors[sentiIndex].opacity(0.2)))
                            .padding(.top, 5)
                            .padding(.bottom)
                        
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("DESCRIPTION")
                                    .font(.senti(size: 12))
                                    .padding(.top, 5)
                                    .lineLimit(15)
                                    .id(1)
                                
                                Group {
                                    if isEditingDescription {
                                        SentiTextEditor(text: $description)
                                            .onTapGesture {
                                                withAnimation {
                                                    scrollView.scrollTo(1, anchor: .top)
                                                }
                                            }
                                    } else {
                                        Text(description.isEmpty ? "Describe your activity..." : description)
                                            .font(.senti(size: 18))
                                            .padding(.bottom)
                                            .opacity(description.isEmpty ? 0.5 : 1)
                                    }
                                }
                                .padding(.top, 1)
                            }
                            Spacer()
                            if isEditingDescription {
                                Button {
                                    dismissKeyboard()
                                    updateActivityDescription(with: description)
                                    withAnimation(.easeOut) {
                                        isEditingDescription = false
                                    }
                                } label: {
                                    Text("Done")
                                        .bold()
                                }
                            } else {
                                Button {
                                    withAnimation(.easeOut) {
                                        isEditingDescription = true
                                    }
                                } label: {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 20)
                                        .padding(13)
                                        .standardBackground()
                                }
                            }
                        }
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
                    DataController.deleteActivity(viewContext: viewContext, id: id)
                    dismiss()
                }
            } message: {
                Text("You cannot undo this action.")
            }
            .navigationTitle(day)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            dismissKeyboard()
                            updateActivityDescription(with: description)
                            withAnimation(.easeOut) {
                                isEditingDescription = false
                            }
                        }
                        .font(.senti(size: 19))
                        .foregroundColor(K.brandColor2)
                    }
                }
            }
        }
    }
    
    func updateActivityDescription(with description: String) {
        print(#function)
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activity: "Walking", icon: "figure.walk", description: "", day: "Today", time: "08:15", duration: "10 min", sentiment: "happy", id: "")
    }
}