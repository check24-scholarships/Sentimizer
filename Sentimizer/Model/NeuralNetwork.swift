import Foundation

func sigmoid(_ x:Double) -> Double {
    return (1.0 / (1.0 + pow(2.718281828, -x)))
}

func sigmoid_prime(_ x: Double) -> Double {
    return x * (1 - x)
}

func mse_prime(_ y_hat: Double, _ y: Double) -> Double {
    return (y_hat - y)
}

func mse(_ y_hat: Double, _ y: Double) -> Double{
    return (y_hat - y) * (y_hat - y)
}

func getParams(arch: [Int], mul: Double) -> ([[[Double]]], [[Double]]) {
    var biases:[[Double]] = []
    var weights:[[[Double]]] = []
    
    for layer in 0 ..< arch.count - 1 {
        biases.append([])
        weights.append([])
        
        for neuron in 0 ..< arch[layer + 1] {
            biases[layer].append(Double.random(in: -1..<1) * mul)
            
            weights[layer].append([])
            
            for _ in 0 ..< arch[layer] {
                weights[layer][neuron].append(mul / sqrt(Double(arch[layer])))
            }
        }
    }
    
    return (weights, biases)
}

class NeuralNetwork {
    var arch:[Int]
    
    var data:[[[Double]]] = [] // [date, date] date = [data, result], data = [double, double] result = [int]
    
    var lr:Double = 1
    
    var weights:[[[Double]]] = []
    var biases:[[Double]] = []
    
    var cWeights:[[[Double]]] = []
    var cBiases:[[Double]] = []
    
    var results:[[Double]] = []
    
    var generator = RandomNumberGeneratorWithSeed(seed: 1000)
    
    init(arch:[Int], data:[[[Double]]]) {
        self.arch = arch
        self.data = data
        
        (weights, biases) = getParams(arch: arch, mul: Double.random(in: -1..<1, using: &generator))
        (cWeights, cBiases) = getParams(arch: arch, mul: 0)
        
        // print("biases", biases)
        // print("weights", weights)
    }
    
    func feedforward (input:[Double]) -> [Double] {
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
        
        // print("results", results)
        
        return results.last!
    }
    
    func backpropagation() {
        var cost = 0.0
        
        for date in data {
            let x = date[0]
            let y = date[1]
            
            let y_hat = feedforward(input: x)
            
            var outer_d:[Double] = []
            
            for i in 0 ..< arch.last! {
                outer_d.append(mse_prime(y_hat[i], y[i]))
                cost += mse(y_hat[i], y[i])
                
                // print("bbb", y_hat, y)
            }
            
            for layer in 0 ..< arch.count - 1 {
                let onion = arch.count - 2 - layer
                
                var prev_d:[Double] = []
                
                for _ in 0 ..< arch[onion] {
                    prev_d.append(0)
                }
                
                for i in 0 ..< arch[onion + 1] {
                    // print("ooo", i, onion + 1, "r", results)
                    outer_d[i] *= sigmoid_prime(results[onion + 1][i])
                }
                
                for neuron in 0 ..< arch[onion + 1] {
                    cBiases[onion][neuron] -= outer_d[neuron]
                    
                    for connection in 0 ..< arch[onion] {
                        cWeights[onion][neuron][connection] -= outer_d[neuron] * results[onion][connection]
                        
                        prev_d[connection] += outer_d[neuron] * weights[onion][neuron][connection]
                    }
                }
                
                // print("HH", prev_d)
                
                outer_d = prev_d
            }
        }
        
        // print("ooo cost: ", cost)
        
        
        // print("total ggg", derivatives, data.count)
    }
    
    func getDerivatives() -> [Double]{
        var derivatives: [Double] = Array(repeating: 0, count: arch.first!)
        
        for date in data {
            let x = date[0]
            
            let _ = feedforward(input: x)
            
            var outer_d:[Double] = Array(repeating: 1, count: arch.last!)
            
            for layer in 0 ..< arch.count - 1 {
                let onion = arch.count - 2 - layer
                
                var prev_d:[Double] = []
                
                for _ in 0 ..< arch[onion] {
                    prev_d.append(0)
                }
                
                for i in 0 ..< arch[onion + 1] {
                    outer_d[i] *= sigmoid_prime(results[onion + 1][i])
                }
                
                for neuron in 0 ..< arch[onion + 1] {
                    cBiases[onion][neuron] -= outer_d[neuron]
                    
                    for connection in 0 ..< arch[onion] {
                        cWeights[onion][neuron][connection] -= outer_d[neuron] * results[onion][connection]
                        
                        prev_d[connection] += outer_d[neuron] * weights[onion][neuron][connection]
                    }
                }
                
                // print("HH", prev_d)
                
                outer_d = prev_d
            }
            
            for i in 0 ..< arch.first! {
                derivatives[i] += outer_d[i]
            }
        }
        
        for i in 0 ..< arch.first! {
            derivatives[i] = derivatives[i] / Double(data.count)
        }
        
        return derivatives
    }
    
    func updateParams(div: Double) {
        for layer in 0 ..< arch.count - 1 {
            for neuron in 0 ..< arch[layer + 1] {
                biases[layer][neuron] += cBiases[layer][neuron] * lr / div
                
                for connection in 0 ..< arch[layer] {
                    weights[layer][neuron][connection] += cWeights[layer][neuron][connection] * lr / div
                }
            }
        }
        
        (cWeights, cBiases) = getParams(arch: arch, mul: 0)
    }
}
