//
//  ContentView.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg, 2022.
//

import SwiftUI
import CoreData

func getEntryData(entries:FetchedResults<Entry>) -> ([String], [[[String]]]) {
    var days:[String] = []
    var content:[[[String]]] = [[[]]]
    
    for entry in entries {
        var day = formatDate(date:entry.date!, format: "EEE, d MMM")
        
        if (Calendar.current.isDateInToday(entry.date!)) {
            day = "Today"
        } else if (Calendar.current.isDateInYesterday(entry.date!)) {
            day = "Yesterday"
        }
        
        if day != days.first {
            days.insert(day, at: 0)
            content.insert([], at: 0)
        }
        
        content[0].insert([entry.activity ?? "senting", formatDate(date: entry.date!, format: "HH:mm"), "10", entry.text ?? "", entry.feeling ?? "happy"], at:0)
    }
                
    
    return (days, content)
}

func formatDate(date: Date, format:String = "dd MM") -> String {
    let d = DateFormatter()
    d.dateFormat = format
    return d.string(from: date)
}


struct MainActivityView: View {
    @EnvironmentObject private var model: Model
    
    @Environment(\.managedObjectContext) var moc
    
    @State var addActivitySheetOpened = false
    
    @State var entryDays:[String] = []
    @State var entryContent:[[[String]]] = [[]]
    
    @FetchRequest var entries: FetchedResults<Entry>
    
    
    var body: some View {
        
        ZStack {
            K.bgColor.ignoresSafeArea()
            ScrollView {
                Group {
                    VStack(alignment: .leading) {
                        ViewTitle("Activities")
                            .padding()
                        
                        SentiButton(icon: "plus.circle", title: "Add Activity")
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .onTapGesture {
                                addActivitySheetOpened = true
                            }
                    }
                    .padding(.vertical, 25)
                    
                    ForEach(0 ..< entryDays.count, id: \.self) { day in
                        VStack(alignment: .leading) {
                            Text(entryDays[day])
                                .font(.senti(size: 25))
                                .padding()
                            
                            ForEach(0 ..< entryContent[day].count, id: \.self) { i in
                                let c = entryContent[day][i]
                                Activity(activity: c[0], description: c[3], time: c[1], duration: c[2], sentiment: c[4])
                            }
                        }
                    }
                }
                .padding(.horizontal, 15)
            }
            .foregroundColor(K.textColor)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $addActivitySheetOpened) {
            AddActivityView()
                .environment(\.managedObjectContext, self.moc)
        }
        
        .onAppear() {
            print("Z appeared")
            
            print("d", Date())
            
            (entryDays, entryContent) = getEntryData(entries: entries)
        }
    }
    
    init() {
        let f:NSFetchRequest<Entry> = Entry.fetchRequest()
        f.fetchLimit = 20
        f.sortDescriptors = [NSSortDescriptor(key: #keyPath(Entry.date), ascending: true)]
        _entries = FetchRequest(fetchRequest: f)
    }
}

//MARK: - Activity Bar
struct Activity: View {
    
    let activity: String
    let description: String?
    let time: String
    let duration: String
    let sentiment: String
    
    @State var width: CGFloat = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(time)
                Text(duration + "min")
            }
            .font(.senti(size: 20))
            .padding([.leading, .top, .bottom])
            .padding(.trailing, 3)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(activity)
                    .padding(.top, 5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .overlay {
                        GeometryReader { g in
                            Color.clear
                                .onAppear {
                                    width = g.frame(in: .local).width
                                    print(width)
                                }
                                .onChange(of: g.frame(in: .local).width) { newValue in
                                    width = newValue
                                    print(width)
                                }
                        }
                    }
                Rectangle()
                    .frame(width: width, height: 5)
                    .foregroundColor(color)
                if let description = description {
                    Text(description)
                        .font(.senti(size: 18))
                        .opacity(0.7)
                        .lineLimit(2)
                        .padding(.bottom, 10)
                }
            }
            
            Spacer()
            
            Image(sentiment)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .font(.largeTitle)
                .padding(20)
                .background(Rectangle().gradientForeground(.leading, .trailing).frame(height: 100))
        }
        .font(.senti(size: 25))
        .foregroundColor(.white)
        .background(
            Rectangle()
                .gradientForeground())
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct MainActivityView_Previews: PreviewProvider {
    static var previews: some View {
        MainActivityView()
            .environmentObject(Model())
    }
}
