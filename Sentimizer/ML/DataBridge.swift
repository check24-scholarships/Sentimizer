//
//  DataBridge.swift
//  Sentimizer
//
//  Created by Henry Pham on 07.07.22.
//

import Foundation

//
//  DataBridge.swift
//  Sentimizer
//
//  Created by Henry Pham on 10.06.22.
//

import SwiftUI
import CoreData

struct User: Decodable{
    let token: String
}
struct DataBridge{
    //let registerURL = "https://sentimizer.codeclub.check24.fun/api/register"
    let postURL = "https://sentimizer.codeclub.check24.fun/api/evaluatedata"
    var userToken = ""
    @FetchRequest var entries: FetchedResults<Entry>
    
    @Environment(\.managedObjectContext) var context
    
    init(){
        let f:NSFetchRequest<Entry> = Entry.fetchRequest()
        _entries = FetchRequest(fetchRequest: f)
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")

                request = NSFetchRequest(entityName: "Entry")

                request.returnsObjectsAsFaults = false

                var results = context.executeFetchRequest(request, error: nil)

                if results!.count > 0 {

                    for result: AnyObject in results! as [Entry] {

                        println(result)
                        println(result.speed)

                    }
                }
                else {
                    println("No data")
                }
    }
    //@FetchRequest(entity: Entry.entity(), sortDescriptors: []) var entries: FetchedResults<Entry>
   
    mutating func getAndPost(userId:String) async throws{
        try await postObjects(urlString: self.postURL, userId: userId)
    }
    //register user and get user_token
    mutating func registerUser(urlString: String) async  throws {
        guard let url = URL(string: urlString) else {fatalError("Missing URL")}
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard(response as? HTTPURLResponse)?.statusCode == 200 else { print((response as? HTTPURLResponse)?.statusCode); fatalError("Error while fetching data")}
            let decodedData = try JSONDecoder().decode(User.self,from: data)
        self.userToken = decodedData.token
    }
    
    // Get data out of Model, diary_entry
    func postObjects(urlString: String, userId: String) async throws{
        var convertedEntries: [String] = []
        print("uwu")
        
        for entry in entries {
            //
            print("asdfasdf")
            print(entry)
            let converted = EntryData(
                activity: entry.activity ?? "None", date: entry.date!, feeling: entry.feeling ?? "neutral", text: entry.text ?? "None"
            )
            
            let encodedData = try! JSONEncoder().encode(converted)
            let jsonString = String(data: encodedData, encoding: .utf8)
            convertedEntries.append(jsonString!)
        }
        //format to dict
        let sendData:[String:Array<String>] = [userId:convertedEntries]
        //send to Server make Post Request
        guard let url = URL(string: urlString) else {fatalError("Missing URL")}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let paramters = sendData
        let encodedDict = try JSONEncoder().encode(paramters)
        urlRequest.httpBody = encodedDict
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        guard(response as? HTTPURLResponse)?.statusCode == 200 else { print((response as? HTTPURLResponse)?.statusCode); fatalError("Error while fetching data")}
        //let decodedData = try JSONDecoder().decode(User.self,from: data)
        
    }
    
    
}

struct EntryData: Codable{
    let activity: String
    let date: Date
    let feeling: String
    let text: String
}
    
    //format to dict
    //send to server
    /*
     send data in dictionary
     [{user_token: diary_entry},{user_token: diary_entry}]
     */

