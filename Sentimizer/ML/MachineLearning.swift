//
//  MachineLearning.swift
//  Sentimizer
//
//  Created by Justin Hohenstein, 2022.
//

import CoreML

struct MachineLearning {
    static func getModel() {
        let defaults = UserDefaults.standard
        
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let modelName = "TestModel.mlmodelc"
        let actualPath = resourceDocPath.appendingPathComponent(modelName)
        
        guard let url = URL(string: "http://127.0.0.1:8000/") else { return }
        let request = URLRequest(url: url)
//        let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                try data.write(to: actualPath)
                
                print(actualPath)
                
                let model = try MLModel.compileModel(at: actualPath)
                
                print("pLs", model)
                
                let permanentURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(model.lastPathComponent)
                _ = try FileManager.default.replaceItemAt(permanentURL, withItemAt: model)
                
                defaults.set(permanentURL.absoluteString, forKey: K.modelURL)
                
                print("absolute", permanentURL, permanentURL.absoluteString)
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    static func feedforward(ip: [Double]) -> [Double] {
        let defaults = UserDefaults.standard
        do {
            let permanentURL = defaults.object(forKey: K.modelURL)
            let model = try TestModel(contentsOf: URL(string: permanentURL as! String)!)
            
            let mlMultiArrayInput = try? MLMultiArray(shape:[1, NSNumber(value: ip.count)], dataType:MLMultiArrayDataType.double)
            
            for i in 0 ..< ip.count {
                mlMultiArrayInput![i] = ip[i] as NSNumber
            }
            
            print("MLI", mlMultiArrayInput as Any)
            
            let output = try model.prediction(input: TestModelInput(ip: mlMultiArrayInput!)).var_6
            
            print(output)
            
            var result:[Double] = []
            
            for i in 0 ..< output.count {
                result.append(Double(truncating: output[i]))
            }
            
            return result
        } catch let error {
            print(error)
        }
        
        return []
    }
}
