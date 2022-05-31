//
//  StatisticsData.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 22.05.22.
//

import SwiftUI
import CoreData

struct StatisticsData {
    static func getMeans(stepSize:Double, rEntries:[[Entry]], i:Int, xValues: [Double], yValues:[Double]) -> ([Double], [Double]) {
        var xValues:[Double] = xValues
        var yValues: [Double] = yValues
        
        var mean:Double = 0
        
        for entry in rEntries[i] {
            mean += SentiScoreHelper.getSentiScore(for: entry.feeling!)
        }
        
        if rEntries[i].count != 0 {
            yValues.append(mean / Double(rEntries[i].count))
            xValues.append(stepSize * Double(i))
        }
        
        return (xValues, yValues)
    }
    
    static func getStats(entries: FetchedResults<Entry>, interval: String, stamps: Int = 5) -> ([String], ([Double], [Double])){
        // dataController.deleteAllData(viewContext: viewContext)
        // dataController.addSampleData(viewContext: viewContext)
        var xValues:[Double] = []
        var yValues: [Double] = []
        
        var xAxis:[String] = []
        
        if interval == K.timeIntervals[0] {
            var rEntries:[Entry] = []
            
            var firstTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())?.timeIntervalSince1970
            var lastTime = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())?.timeIntervalSince1970
            
            for entry in entries {
                if Calendar.current.isDateInToday(entry.date!) {
                    rEntries.insert(entry, at:0)
                }
            }
            
            if rEntries.count >= 1 {
                firstTime = rEntries[0].date!.timeIntervalSince1970
            }
            
            if rEntries.count >= 2 {
                lastTime = rEntries.last!.date!.timeIntervalSince1970
            }
            
            let stepSize = (lastTime! - firstTime!) / Double(stamps - 1)
            
            for i in 0..<stamps {
                xAxis.append(DateFormatter.formatDate(date: Date(timeIntervalSince1970: firstTime! + stepSize * Double(i)), format: "HH:mm"))
            }
            
            var lastValue:Double = -1
            
            for entry in rEntries {
                yValues.append(SentiScoreHelper.getSentiScore(for: entry.feeling!))
                var xValue = (entry.date!.timeIntervalSince1970 - firstTime!) / (lastTime! - firstTime!)
                if xValue - lastValue < 0.1 {
                    xValue = lastValue + 0.1
                }
                
                xValues.append(xValue)
                
                lastValue = xValue
            }
            
            if lastValue > 1 {
                for i in 0..<xValues.count {
                    xValues[i] = xValues[i] / lastValue
                }
            }
        } else if interval == K.timeIntervals[1] {
            var rEntries:[[Entry]] = [[], [], [], [], [], [], []]
            
            let firstTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!.timeIntervalSince1970 - (60 * 60 * 24 * 6)
            let lastTime = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!.timeIntervalSince1970
            
            for entry in entries {
                let entryDate = entry.date!.timeIntervalSince1970
                
                let dIndex = (Calendar.current.dateComponents([.weekday], from: entry.date!).weekday! - 1) + 6 - (Calendar.current.dateComponents([.weekday], from: Date()).weekday! - 1)
                
                if firstTime < entryDate && entryDate < lastTime {
                    rEntries[dIndex < 7 ? dIndex : dIndex - 7].insert(entry, at:0)
                }
            }
            
            for i in 0..<7 {
                xAxis.insert(DateFormatter.formatDate(date: Date(timeIntervalSince1970: lastTime - Double(60 * 60 * 24 * i)), format: "EE"), at:0)
                
                (xValues, yValues) = getMeans(stepSize: 1 / 6, rEntries: rEntries, i: i, xValues: xValues, yValues: yValues)
            }
        } else if interval == K.timeIntervals[2] {
            var rEntries:[[Entry]] = []
            
            let day = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: Date())))!
            let firstTime = day.timeIntervalSince1970
            let lastTime = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: day)!.timeIntervalSince1970
            
            
            let stepSize = (lastTime - firstTime) / Double(stamps - 1)
            
            for i in 0..<stamps {
                rEntries.append([])
                rEntries.append([])
                xAxis.append(DateFormatter.formatDate(date: Date(timeIntervalSince1970: firstTime + stepSize * Double(i)), format: "d MMM"))
            }
            
            for entry in entries {
                let entryDate = entry.date!.timeIntervalSince1970
                
                if firstTime < entryDate && entryDate < lastTime {
                    rEntries[Int((entryDate - firstTime) / (stepSize / 2))].append(entry)
                }
            }
            
            for i in 0..<(stamps * 2) {
                (xValues, yValues) = getMeans(stepSize: 1 / Double(((2 * stamps) - 1)), rEntries: rEntries, i: i, xValues: xValues, yValues: yValues)
            }
        } else if interval == K.timeIntervals[3] {
            var rEntries:[[Entry]] = [[], [], [], [], [], [], [], [], [], [], [], []]
            
            let year = Calendar.current.component(.year, from: Date())
            let firstTime = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))!.timeIntervalSince1970
            let lastTime = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1))!)!.timeIntervalSince1970
            
            
            print(Date(timeIntervalSince1970: firstTime), Date(timeIntervalSince1970: lastTime))
            print(firstTime + 60 * 60 * 24 * 31 * 12, lastTime)
            
            for entry in entries {
                let entryDate = entry.date!.timeIntervalSince1970
                
                if firstTime < entryDate && entryDate < lastTime {
                    rEntries[Calendar.current.component(.month, from: entry.date!) - 1].insert(entry, at:0)
                }
            }
            
            for i in 0..<12 {
                xAxis.insert(String(Array(DateFormatter.formatDate(date: Date(timeIntervalSince1970: lastTime - Double(60 * 60 * 24 * 31 * i)), format: "MMM"))[0]), at:0)
                
                (xValues, yValues) = getMeans(stepSize: 1 / 11, rEntries: rEntries, i: i, xValues: xValues, yValues: yValues)
            }
        }
        
        return (xAxis, (xValues, yValues))
    }
    
    static func getCount(interval: String, viewContext: NSManagedObjectContext) -> [Int] {
        let request = Entry.fetchRequest()
        var count:[Int] = [0, 0, 0, 0, 0]
        var lastTime: Double = 0
        
        if interval == K.timeIntervals[0] {
            lastTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!.timeIntervalSince1970
        } else if interval == K.timeIntervals[1] {
            lastTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!.timeIntervalSince1970 - (60 * 60 * 24 * 6)
        } else if interval == K.timeIntervals[2] {
            lastTime = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: Date())))!.timeIntervalSince1970
        } else if interval == K.timeIntervals[3] {
            lastTime = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: 1, day: 1))!.timeIntervalSince1970
        }
        
        do {
            let entries = try viewContext.fetch(request)
            
            for entry in entries {
                if entry.date!.timeIntervalSince1970 > lastTime {
                    count[SentiScoreHelper.getSentiIndex(for: entry.feeling!)] += 1
                }
            }
        } catch {
            print("In \(#function), line \(#line), get mood count failed:")
            print(error.localizedDescription)
        }
        
        return count
    }
    
    static func getInfluence(viewContext: NSManagedObjectContext, interval: String, activities: FetchedResults<Activity>) -> (([String], [Double]), ([String], [Double])){
        var allActivities:[String] = K.defaultActivities.0.map { $0.copy() as! String }
        
        for activity in activities {
            allActivities.append(activity.name!)
        }
        
        let neuralNetwork = NeuralNetwork(arch: [allActivities.count, 20, 1], data: [])
        
        let request = Entry.fetchRequest()
        var lastTime:Double = 0
        
        if interval == K.timeIntervals[0] {
            // lastTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!.timeIntervalSince1970
            
            
            lastTime = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: Date())))!.timeIntervalSince1970
        } else if interval == K.timeIntervals[1] {
            // lastTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!.timeIntervalSince1970 - (60 * 60 * 24 * 6)
            
            lastTime = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: Date())))!.timeIntervalSince1970
        } else if interval == K.timeIntervals[2] {
            lastTime = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: Date())))!.timeIntervalSince1970
        } else if interval == K.timeIntervals[3] {
            lastTime = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: 1, day: 1))!.timeIntervalSince1970
        }
        
        do {
            let entries = try viewContext.fetch(request)
            
            var lastDate = Date()
            
            var x: [[Double]] = []
            var y: [[Double]] = []
            
            for entry in entries {
                if entry.date!.timeIntervalSince1970 < lastTime {
                    continue
                }
                
                if x.count == 0 || !Calendar.current.isDate(lastDate, inSameDayAs: entry.date!) {
                    x.append([])
                    y.append([0])
                    
                    var empty:[Double] = []
                    
                    for _ in 0 ..< (allActivities.count) {
                        empty.append(0)
                    }
                    
                    x[x.count - 1].append(contentsOf: empty)
                    
                    lastDate = entry.date!
                }
                
                x[x.count - 1][allActivities.firstIndex(of: entry.activity!)!] += 1
                y[y.count - 1][0] += SentiScoreHelper.getSentiScore(for: entry.feeling!)
            }
            
            // data: [[[1, 0], [0, 0]]]
            
            for i in 0 ..< x.count {
                var normalized: [Double] = x[i]
                
                for j in 0 ..< normalized.count {
                    normalized[j] = normalized[j] / (1 + normalized[j])
                }
                
                neuralNetwork.data.append([normalized, [y[i][0] / x[i].reduce(.zero, +)]])
                
                // print("ccc", x[i], x[i].reduce(.zero, +), [y[i][0] / x[i].reduce(.zero, +)], y[i])
            }
            
            
            // print("dab", neuralNetwork.data)
            
            for _ in 0 ..< 200 {
                neuralNetwork.backpropagation()
                neuralNetwork.updateParams(div: Double(x.count) / 15)
            }
            
            var derivatives = neuralNetwork.getDerivatives()
            
            // print("data", neuralNetwork.data)
            // print("d", derivatives)
            
            let num = 3
            
            var improved = (Array.init(repeating: "", count: num), Array.init(repeating: 0.0, count: num))
            var worsened = (Array.init(repeating: "", count: num), Array.init(repeating: 0.0, count: num))
            
            var smallIndex = 0
            var biggestIndex = 0
            
            for n in 0 ..< num {
                for d in 0 ..< derivatives.count {
                    if derivatives[d] > improved.1[n] {
                        if derivatives[d] < 0.8 {
                            improved.1[n] = derivatives[d]
                        } else {
                            improved.1[n] = 0.8
                        }
                        
                        improved.0[n] = allActivities[d]
                        biggestIndex = d
                    } else if derivatives[d] < worsened.1[n] {
                        if derivatives[d] > -0.8 {
                            worsened.1[n] = derivatives[d]
                        } else {
                            worsened.1[n] = -0.8
                        }
                        
                        worsened.0[n] = allActivities[d]
                        smallIndex = d
                    }
                }
                
                derivatives[smallIndex] = 0
                derivatives[biggestIndex] = 0
            }
            
            // return (improved, worsened)
            
            var res: (([String], [Double]), ([String], [Double])) = (([], []), ([], []))
            
            for n in 0 ..< num {
                if improved.1[n] > 0.01 {
                    res.0.0.append(improved.0[n])
                    res.0.1.append(improved.1[n])
                }
                
                if worsened.1[n] < -0.01 {
                    res.1.0.append(worsened.0[n])
                    res.1.1.append(worsened.1[n])
                }
            }
            
            return res
            
        } catch {
            print("In \(#function), line \(#line), save activity failed:")
            print(error.localizedDescription)
        }
        
        return ((["Soccer"], [0.5]), (["Project"], [-0.2]))
    }
}
