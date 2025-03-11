//
//  Level.swift
//  GeoStreak
//
//  Created by Pranav Suri
//

import Foundation
import SwiftUI

struct Level: Identifiable {
    let id: Int
    let name: String
    let description: String
    let requiredCorrectAnswers: Int
    let continent: String
    let color: Color
    let icon: String
    
    static let allLevels: [Level] = [
        Level(id: 1,
              name: "Novice Explorer",
              description: "European capitals",
              requiredCorrectAnswers: 10,
              continent: "Europe",
              color: .blue,
              icon: "globe.europe.africa.fill"),
        
        Level(id: 2,
              name: "Adventurer",
              description: "Asian capitals",
              requiredCorrectAnswers: 15,
              continent: "Asia",
              color: .red,
              icon: "globe.asia.australia.fill"),
        
        Level(id: 3,
              name: "Voyager",
              description: "American capitals",
              requiredCorrectAnswers: 20,
              continent: "Americas",
              color: .green,
              icon: "globe.americas.fill"),
        
        Level(id: 4,
              name: "Globe Trotter",
              description: "African capitals",
              requiredCorrectAnswers: 25,
              continent: "Africa",
              color: .orange,
              icon: "globe.europe.africa.fill"),
        
        Level(id: 5,
              name: "Geography Master",
              description: "Oceania & challenging capitals",
              requiredCorrectAnswers: 30,
              continent: "Oceania",
              color: .purple,
              icon: "globe.asia.australia.fill")
    ]
    
    // Get level for a specific ID
    static func getLevel(id: Int) -> Level {
        return allLevels.first { $0.id == id } ?? allLevels[0]
    }
    
    // Get next level
    static func getNextLevel(current: Int) -> Level? {
        guard current < allLevels.count else { return nil }
        return allLevels.first { $0.id == current + 1 }
    }
}
