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
    var entries = PersistenceController().getAllEntries(PersistenceController.context)
    
    //@FetchRequest(entity: Entry.entity(), sortDescriptors: []) var entries: FetchedResults<Entry>
   
    mutating func getAndPost(userId:String) async throws {
        try await postObjects(urlString: self.postURL, userId: userId)
    }
    
    //register user and get user_token
    mutating func registerUser(urlString: String) async throws {
        guard let url = URL(string: urlString) else { print("Missing URL in DataBridge, registerUser"); return }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard(response as? HTTPURLResponse)?.statusCode == 200 else { print((response as? HTTPURLResponse)?.statusCode ?? "Cannot print status code"); print("In \(#function), line \(#line)"); return }
            let decodedData = try JSONDecoder().decode(User.self,from: data)
        self.userToken = decodedData.token
    }
    
    // Get data out of Model, diary_entry
    func postObjects(urlString: String, userId: String) async throws {
        var convertedEntries: [String] = []
        
        for entry in entries {
            //
            let converted = EntryData(
                activity: entry.activity , date: entry.date, feeling: entry.sentiment , text: entry.description
            )
            
            let encodedData = try JSONEncoder().encode(converted)
            guard let jsonString = String(data: encodedData, encoding: .utf8) else { return }
            convertedEntries.append(jsonString)
        }
        //format to dict
        let sendData:[String:Array<String>] = [userId:convertedEntries]
        //send data to server make Post Request
        guard let url = URL(string: urlString) else { print("Missing URL in DataBridge, postObjects"); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let paramters = sendData
        let encodedData = try JSONEncoder().encode(paramters)
        urlRequest.httpBody = encodedData
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        guard(response as? HTTPURLResponse)?.statusCode == 200 else { print((response as? HTTPURLResponse)?.statusCode ?? "Cannot print status code"); print("In \(#function), line \(#line)"); return }
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

