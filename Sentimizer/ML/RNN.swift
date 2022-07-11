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
            print("CURL", defaults.object(forKey: K.modelURL + "in_net") as? String ?? "/")
            self.inNet = try! in_net(contentsOf: URL(string: defaults.object(forKey: K.modelURL + "in_net") as? String ?? "/")!)
            print("innerL", inNet)
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
        // saveMModel(modelName: "out_net")
        saveMModel(modelName: "in_net")
    }
        
    public func saveMModel(modelName: String) {
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let actualPath = resourceDocPath.appendingPathComponent(modelName + ".mlmodelc")
        
        guard let url = URL(string: K.serverURL + "send_m_" + modelName + "/") else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                try data.write(to: actualPath)
                
                let model = try MLModel.compileModel(at: actualPath)
                
                print("saved one: ", model)
                
                let permanentURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(model.lastPathComponent)
                _ = try FileManager.default.replaceItemAt(permanentURL, withItemAt: model)
                
                self.defaults.set(permanentURL.absoluteString, forKey: K.modelURL + modelName)
                
                let mlMultiArrayInput = try? MLMultiArray(shape:[5], dataType:MLMultiArrayDataType.double)
                
                mlMultiArrayInput![0] = 0.1 as NSNumber
                mlMultiArrayInput![1] = 0.2 as NSNumber
                mlMultiArrayInput![2] = 0.4 as NSNumber
                mlMultiArrayInput![3] = 0.2 as NSNumber
                mlMultiArrayInput![4] = 0.2 as NSNumber
                
                print("MLI", mlMultiArrayInput as Any)
                
                let Emodel = try in_net(contentsOf: permanentURL)
                
                print("CURL emol", Emodel)
                
                let output = try! Emodel.prediction(input: in_netInput(x: mlMultiArrayInput!)).var_6
                
                print("saved one output pls", output[0])
                
                print("CURL PERM", permanentURL.absoluteString, modelName)
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
