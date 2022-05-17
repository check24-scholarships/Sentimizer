import Foundation

func sigmoid(_ x:Double) -> Double {
    return (1.0 / (1.0 + pow(2.718281828, -x)))
}

func sigmoid_prime(_ x: Double) -> Double {
    return x * (x - 1)
}

func mse_prime(_ y_hat: Double, _ y: Double) -> Double {
    return (y_hat - y)
}

func mse(_ y_hat: Double, _ y: Double) -> Double{
    return (y_hat - y) * (y_hat - y)
}

class NeuralNetwork {
    var arch:[Int]
    
    var data:[[[Double]]] // [date, date] date = [data, result], data = [double, double] result = [int]
    
    var weights:[[[Double]]] = []
    var biases:[[Double]] = []
    
    var results:[[Double]] = []
    
    init(arch:[Int], data:[[[Double]]]) {
        self.arch = arch
        self.data = data
        
        for layer in 0 ..< self.arch.count - 1 {
            self.biases.append([])
            self.weights.append([])
            
            for neuron in 0 ..< self.arch[layer + 1] {
                self.biases[layer].append(Double.random(in: -1..<1))
                
                self.weights[layer].append([])
                
                for _ in 0 ..< self.arch[layer] {
                    self.weights[layer][neuron].append(Double.random(in: -1..<1))
                }
            }
        }
        
        print("biases", biases)
        print("weights", weights)
    }
    
    func feedforward (input:[Double]) {
        var input:[Double] = input
        
        results = [input]
        
        for layer in 0 ..< self.arch.count - 1 {
            var result:[Double] = []
            
            for neuron in 0 ..< self.arch[layer + 1] {
                result.append(self.biases[layer][neuron])
                
                for connection in 0 ..< self.arch[layer] {
                    result[neuron] += input[connection] * self.weights[layer][neuron][connection]
                }
                
                result[neuron] = sigmoid(result[neuron])
            }
            
            results.append(result)
            
            input = result
        }
        
        print("results", results)
    }
    
    func backpropagtion() {
        
        
        for date in data {
            let x = date[0]
            let y = date[1]
            
            print(x, y)
            
            let outer_d:[Double] = []
            
            for i in 0 ..< arch.last! {
                
            }
            
            for layer in 0 ..< arch.count - 1 {
                let onion = arch.count - 1 - layer
                
                for neuron in 0 ..< arch[onion] {
                    for connection in 0 ..< arch[onion - 1] {
                        print("arch", onion, neuron, connection)
                    }
                }
            }
        }
    }
}
