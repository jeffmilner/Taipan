//
//  Models.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import Foundation

// MARK: - Game Models

struct Commodity {
    let name: String
    var basePrice: [Int]  // Price in each port
}

struct Port {
    let name: String
}

class GameState: ObservableObject {
    @Published var cash: Int = 0
    @Published var bank: Int = 0
    @Published var debt: Int = 0
    @Published var shipCapacity: Int = 60
    @Published var shipDamage: Int = 0
    @Published var guns: Int = 0
    @Published var currentLoad: Int = 0
    @Published var warehouseCapacity: Int = 10000
    @Published var warehouseUsed: Int = 0
    @Published var year: Int = 1860
    @Published var month: Int = 1
    @Published var currentPort: Int = 1
    @Published var destinationPort: Int = 0
    @Published var firmName: String = ""
    @Published var timeTraded: Int = 1
    @Published var economic: Int = 20
    @Published var economicDamage: Double = 0.5
    @Published var battleProtection: Int = 0
    @Published var liYuenStatus: Int = 0
    @Published var bankLoanCount: Int = 0
    
    @Published var shipStorage: [[Int]] = Array(repeating: Array(repeating: 0, count: 4), count: 2)
    @Published var commodityPrices: [Int] = Array(repeating: 0, count: 4)
    var warehouseStorage: [Int] {
        get { return shipStorage[0] }
        set { shipStorage[0] = newValue }
    }
    var shipInventory: [Int] {
        get { return shipStorage[1] }
        set { shipStorage[1] = newValue }
    }
    
    let ports: [Port] = [
        Port(name: "At sea"),
        Port(name: "Hong Kong"),
        Port(name: "Shanghai"),
        Port(name: "Nagasaki"),
        Port(name: "Saigon"),
        Port(name: "Manila"),
        Port(name: "Singapore"),
        Port(name: "Batavia")
    ]
    
    var commodities: [Commodity] = [
        Commodity(name: "Opium", basePrice: [0, 11, 16, 15, 14, 12, 10, 13]),
        Commodity(name: "Silk", basePrice: [0, 11, 14, 15, 16, 10, 13, 12]),
        Commodity(name: "Arms", basePrice: [0, 12, 16, 10, 11, 13, 14, 15]),
        Commodity(name: "General Cargo", basePrice: [0, 10, 11, 12, 13, 14, 15, 16])
    ]
    
    let shipStatusDescriptions = ["Critical", "Poor", "Fair", "Good", "Prime", "Perfect"]
    
    func random(_ max: Int) -> Int {
        return Int.random(in: 0..<max)
    }
    
    // Similar to the original BASIC function FN R(X)
    func fnR(_ x: Int) -> Int {
        guard x > 0 else {
            print("Warning: fnR called with non-positive value \(x). Returning 0.")
            return 0
        }
        return Int.random(in: 0..<x)
    }
    
    init() {
        setupNewGame(withGuns: false)
    }
    
    func setupNewGame(withGuns: Bool) {
        month = 1
        year = 1860
        shipCapacity = 60
        shipDamage = 0
        bank = 0
        currentPort = 1
        timeTraded = 1
        warehouseCapacity = 10000
        warehouseUsed = 0
        shipStorage = Array(repeating: Array(repeating: 0, count: 4), count: 2)
        
        if withGuns {
            debt = 0
            cash = 0
            currentLoad = 10
            guns = 5
            battleProtection = 7
        } else {
            debt = 5000
            cash = 400
            currentLoad = 0
            guns = 0
            battleProtection = 10
        }
        
        economic = 20
        economicDamage = 0.5
        
        // Initialize commodity prices
        updateCommodityPrices()
    }
    
    func getShipStatus() -> String {
        let percentage = 100 - Int(Double(shipDamage) / Double(shipCapacity) * 100.0 + 0.5)
        let statusIndex = max(0, min(percentage / 20, 5))
        return shipStatusDescriptions[statusIndex]
    }
    
    func getShipStatusPercentage() -> Int {
        return 100 - Int(Double(shipDamage) / Double(shipCapacity) * 100.0 + 0.5)
    }
    
    func updateCommodityPrices() {
        for i in 0..<4 {
            let basePrice = commodities[i].basePrice[currentPort]
            commodityPrices[i] = basePrice / 2 * (fnR(3) + 1) * Int(pow(10.0, Double(4 - i)))
        }
    }
    
    func formatLargeNumber(_ number: Int) -> String {
        if number < 1_000_000 {
            return "\(number)"
        }
        
        let log10 = log10(Double(number))
        let intLog = Int(log10)
        let grouping = (intLog / 3) * 3
        let factor = pow(10.0, Double(intLog - 2))
        //let scaledNum = Int(Double(number) / factor + 0.5) * factor / pow(10.0, Double(grouping))
        
        let scaledNum = (Double(Int(Double(number) / factor + 0.5)) * factor) / pow(10.0, Double(grouping))
            
        var suffix = ""
        switch grouping {
        case 3: suffix = "Thousand"
        case 6: suffix = "Million"
        case 9: suffix = "Billion"
        case 12: suffix = "Trillion"
        default: break
        }
        
        return String(format: "%.1f \(suffix)", scaledNum)
    }
    
    func advanceTime() {
        bank = Int(Double(bank) + Double(bank) * 0.005)
        debt = Int(Double(debt) + Double(debt) * 0.1)
        timeTraded += 1
        month += 1
        
        if month > 12 {
            year += 1
            month = 1
            economic += 10
            economicDamage += 0.5
            
            // Update base prices
            for i in 1...7 {
                for j in 0..<4 {
                    commodities[j].basePrice[i] += fnR(2)
                }
            }
        }
        
        updateCommodityPrices()
    }
    
    func netWorth() -> Int {
        return cash + bank - debt
    }
}
