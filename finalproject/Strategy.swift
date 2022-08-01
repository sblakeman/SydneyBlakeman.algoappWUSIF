//
//  Strategy.swift
//  finalproject
//
//  Created by Sydney Blakeman on 7/31/22.
//

import Foundation

struct Strategy: Codable {
    let title: String
    let startAmount: Double
    
    let peRatio: Double?
    let pBvRatio: Double?
    let deRatio: Double?
    let curRatio: Double?
    let roeRatio: Double?
    let minRatio: Double?
    
    var trend: Trend {
        let amount = 100.0

        if amount > startAmount {
            return .up
        } else if amount < startAmount {
            return .down
        }
        
        return .neutral
    }
    
    enum Trend: String {
        case up = "arrow.up"
        case down = "arrow.down"
        case neutral = "circle.and.line.horizontal"
    }
}
