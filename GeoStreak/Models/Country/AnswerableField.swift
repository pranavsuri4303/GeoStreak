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
    var valueT: T
    let difficulty: Int

    var value: Any {
        return valueT as Any
    }
    
    init(value: T, difficulty: Int) {
        self.valueT = value
        self.difficulty = Self.clamp(difficulty, min: 1, max: 5)
    }
    
    private static func clamp(_ value: Int, min: Int, max: Int) -> Int {
        Swift.max(min, Swift.min(max, value))
    }
}
