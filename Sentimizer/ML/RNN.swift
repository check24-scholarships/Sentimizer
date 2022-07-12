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
        // fetchMNets()
    }
    
    public func fetchMNets() {
        self.inNet = fetchMNet(name: "in_net")
        self.outNet = fetchMNet(name: "out_net")
        
        print("LOL_", self.inNet ?? "inFail", self.outNet ?? "outNet")
    }
    
    public func fetchMNet(name: String) -> in_net? {
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
        
        saveTModel(name: "out_net")
        saveTModel(name: "in_net")
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
    
    public func saveTModel(name: String) {
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let modelName = name + ".pt"
        let actualPath = resourceDocPath.appendingPathComponent(modelName)
        
        guard let url = URL(string: "http://127.0.0.1:8000/send_t_" + name + "/") else { return }
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
    
    public func sendTNets() {
        print("sending nets")
        sendTNet(name: "in_net")
        sendTNet(name: "out_net")
    }
    
    public func sendTNet(name: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/save_" + name + "/") else { return }
        
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let modelName = name + ".pt"
        let fileURL = resourceDocPath.appendingPathComponent(modelName)
        
        let fileName = fileURL.lastPathComponent
        let paramName = "file"
        let fileData = try? Data(contentsOf: fileURL)
        var data = Data()
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(".pt")\r\n\r\n".data(using: .utf8)!)
        data.append(fileData!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.setValue(String(data.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = data
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            print("request done")
        })
        
        task.resume()
    }
    
    public func validNets() -> Bool {
        return !(self.inNet == nil && self.outNet == nil)
    }
}
