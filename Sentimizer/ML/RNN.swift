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
        do {
            self.inNet = try in_net(contentsOf: URL(string: defaults.object(forKey: K.modelURL + "in_net") as? String ?? "/")!)
            
            self.outNet = try in_net(contentsOf: URL(string: defaults.object(forKey: K.modelURL + "out_net") as? String ?? "/")!)
        } catch let error {
            print("Tell me", error)
        }
    }
    
    public func trainNets() {
        let url = URL(string: K.serverURL + "train_nets/")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            self.saveModels()
        }

        task.resume()
    }
    
    public func saveModels() {
        saveMModel(modelName: "out_net")
        saveMModel(modelName: "in_net")
    }
        
    public func saveMModel(modelName: String) {
        let defaults = UserDefaults.standard
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let modelName = modelName + ".mlmodelc"
        let actualPath = resourceDocPath.appendingPathComponent(modelName)
        
        guard let url = URL(string: "http://127.0.0.1:8000/send_m_" + modelName + "/") else { return }
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
