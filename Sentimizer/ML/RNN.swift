//
//  RNN.swift
//  Sentimizer
//
//  Created by Justin Hohenstein on 11.07.22.
//

import Foundation
import CoreML

class RNN {
    var inNet: in_net?
    var outNet: in_net?
    
    let defaults = UserDefaults.standard
    
    init() {
        // fetch_nets()
    }
    
    public func fetch_nets() {
        self.inNet = fetch_net(name: "in_net")
        self.outNet = fetch_net(name: "out_net")
        
        print("LOL_", self.inNet ?? "inFail", self.outNet ?? "outNet")
    }
    
    public func fetch_net(name: String) -> in_net? {
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let modelName = name + ".mlmodelc"
        let fileURL = resourceDocPath.appendingPathComponent(modelName)
        
        do {
            let modelC = try MLModel.compileModel(at: fileURL)
            
            let permanentURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(modelC.lastPathComponent)
            _ = try FileManager.default.replaceItemAt(permanentURL, withItemAt: modelC)
            
            return try in_net(contentsOf: permanentURL)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    public func trainNets() {
        let url = URL(string: K.serverURL + "train_nets/")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            self.saveModels()
        }

        task.resume()
    }
    
    public func saveModels() {
        saveMModel(name: "out_net")
        saveMModel(name: "in_net")
    }
        
    public func saveMModel(name: String) {
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let modelName = name + ".mlmodelc"
        let actualPath = resourceDocPath.appendingPathComponent(modelName)
        
        guard let url = URL(string: "http://127.0.0.1:8000/send_m_" + name + "/") else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                try data.write(to: actualPath)
            } catch let error {
                print(error)
            }
        }
        
        task.resume()
    }
    
    public func sendNets() {
        print("sending nets")
    }
    
    public func validNets() -> Bool {
        return !(self.inNet == nil && self.outNet == nil)
    }
}
