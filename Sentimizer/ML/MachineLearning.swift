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
        
        guard let url = URL(string: "http://127.0.0.1:8000/test/") else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                try data.write(to: actualPath)
                
                print("dataPath", actualPath, data)
                
                defaults.set(actualPath, forKey: K.modelURL)
            } catch let error {
                print(error)
            }
        }
        
        task.resume()
    }
    
    static func getTorch() {
        let defaults = UserDefaults.standard
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let modelName = "TestModel.pt"
        let actualPath = resourceDocPath.appendingPathComponent(modelName)
        
        guard let url = URL(string: "http://127.0.0.1:8000/send_t_in_net/") else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                try data.write(to: actualPath)
                
                print("dataPath", actualPath, data)
                
                defaults.set(actualPath, forKey: K.torchURL)
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    static func sendTorch() {
        guard let url = URL(string: "http://127.0.0.1:8000/save_in_net/") else { return }
        
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // request.addValue("Bearer \(yourAuthorizationToken)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let modelName = "TestModel.pt"
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
    
    static func feedRNN() {
        let defaults = UserDefaults.standard
        
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let modelName = "rnn.mlmodelc"
        let actualPath = resourceDocPath.appendingPathComponent(modelName)
        
        guard let url = URL(string: "http://127.0.0.1:8000/gr") else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                try data.write(to: actualPath)
                
                print(actualPath)
                
                let modelP = try MLModel.compileModel(at: actualPath)
                
                let permanentURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(modelP.lastPathComponent)
                _ = try FileManager.default.replaceItemAt(permanentURL, withItemAt: modelP)
                
                // print("pLsRNN", model)
                
                let model = try TestModel(contentsOf: permanentURL)
                
                let ip = [[[0.1, 0.2]], [[0.2, 0.4]], [[0.4, 0.6]]]
                
                let mlMultiArrayInput = try? MLMultiArray(shape:[3, 1, 2], dataType:MLMultiArrayDataType.double)
                
                let t = MLMultiArray()
                
                //                for i in 0 ..< ip.count {
                //                    for j in 0 ..< ip[i].count {
                //                        for k in 0 ..< ip[i][j].count {
                //                            mlMultiArrayInput![i] = ip[i][j]
                //                        }
                //                    }
                //                }
                
                print("MLMA", mlMultiArrayInput)
                
                // print("WWTTFF", try! model.prediction(input: TestModelInput(ip: mlMultiArrayInput)))
                
                let output = try model.prediction(input: TestModelInput(ip: mlMultiArrayInput!)).var_6
                print("WHY??")
                print("op", output)
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    static func feedforward(ip: [Double]) -> [Double] {
        let defaults = UserDefaults.standard
        do {
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let modelName = "TestModel.mlmodelc"
            let fileURL = resourceDocPath.appendingPathComponent(modelName)
            
            print("AP_", fileURL, "end")
            
            let modelC = try MLModel.compileModel(at: fileURL)
            
            print("pLs_", modelC)
            
            let permanentURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(modelC.lastPathComponent)
            _ = try FileManager.default.replaceItemAt(permanentURL, withItemAt: modelC)
            
            let model = try TestModel(contentsOf: permanentURL)
            
            print("Actual Model_", model)
            
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
