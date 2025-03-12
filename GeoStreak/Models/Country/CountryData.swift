//
//  CountryData.swift
//  GeoStreak
//
//  Created by Pranav Suri
//

import Foundation
import SwiftData

struct CountryData: Codable, Identifiable {
    let id: String
    let flag: String

    let name: AnswerableField<String>
    let capital: AnswerableField<String>?
    let largestCity: AnswerableField<String>?
    let officialLanguages: AnswerableField<[String]>?
    let currency: AnswerableField<String>?
    
    let continent: String
    let funFacts: [String]?
    let summary: String?
    let areaSquareKm: Int?
    let nationalAnimal: String?
    let climate: String?
    
    var answerableFields: [(key: String, value: Any, difficulty: Int)] {
        var fields: [(key: String, value: Any, difficulty: Int)] = [
            ("name", name.value, name.difficulty)
        ]
        
        if let capital = capital { fields.append(("capital", capital.value, capital.difficulty)) }
        if let largestCity = largestCity { fields.append(("largestCity", largestCity.value, largestCity.difficulty)) }
        if let officialLanguages = officialLanguages { fields.append(("officialLanguages", officialLanguages.value, officialLanguages.difficulty)) }
        if let currency = currency { fields.append(("currency", currency.value, currency.difficulty)) }
        return fields
    }
    
    var level: Int {
        let fields = answerableFields
        return fields.map { $0.difficulty }.reduce(0, +) / (fields.count > 0 ? fields.count : 1)
    }
    
    var answerableFieldKeys: [String] {
        answerableFields.map { $0.key }
    }
    
    var flagUrl: String {
        "https://flagcdn.com/128x96/\(id.lowercased()).png"
    }
    
    /// Gets a specific field value if it exists
    /// - Parameter key: The field key
    /// - Returns: The field value as Any? or nil if not found
    func getValue(forField key: String) -> Any? {
        switch key {
        case "name":
            return name.value
        case "capital":
            return capital?.value
        case "largestCity":
            return largestCity?.value
        case "officialLanguages":
            return officialLanguages?.value
        case "currency":
            return currency?.value
        default:
            return nil
        }
    }
    
    /// Gets the difficulty level for a specific field
    /// - Parameter key: The field key
    /// - Returns: Difficulty level or 0 if field not found
    func getDifficulty(forField key: String) -> Int {
        switch key {
        case "name":
            return name.difficulty
        case "capital":
            return capital?.difficulty ?? 0
        case "largestCity":
            return largestCity?.difficulty ?? 0
        case "officialLanguages":
            return officialLanguages?.difficulty ?? 0
        case "currency":
            return currency?.difficulty ?? 0
        default:
            return 0
        }
    }
    
    /// Get a formatted display string for a field value
    /// - Parameter key: The field key
    /// - Returns: Formatted string representation
    func getDisplayString(forField key: String) -> String {
        guard let value = getValue(forField: key) else { return "Unknown" }
        
        if let stringValue = value as? String {
            return stringValue
        } else if let stringArray = value as? [String] {
            return stringArray.joined(separator: ", ")
        } else {
            return "\(value)"
        }
    }
}
