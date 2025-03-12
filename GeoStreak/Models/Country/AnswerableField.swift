//
//  AnswerableField.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-12.
//
import Foundation

protocol Answerable {
    var difficulty: Int { get }
    var value: Any { get }
}

struct AnswerableField<T: Codable>: Codable, Answerable {
    let rawValue: T // Renamed from `value` to `rawValue`
    let difficulty: Int

    // Satisfy the Answerable protocol
    var value: Any {
        return rawValue as Any
    }
    
    init(value: T, difficulty: Int) {
        self.rawValue = value
        self.difficulty = Self.clamp(difficulty, min: 1, max: 5)
    }
    
    private static func clamp(_ value: Int, min: Int, max: Int) -> Int {
        Swift.max(min, Swift.min(max, value))
    }
    
    enum CodingKeys: String, CodingKey {
        case rawValue = "value"
        case difficulty
    }
}
