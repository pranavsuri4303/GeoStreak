//
//  CountryProgress.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-12.
//
import Foundation
import SwiftData

@Model
final class CountryProgress {
    @Attribute(.unique) var countryId: String
    var unlockedFields: [String: Bool]
    
    init(countryId: String, availableFields: [String], unlockedFields: [String: Bool] = [:]) {
        self.countryId = countryId
        self.unlockedFields = availableFields.reduce(into: [:]) { $0[$1] = unlockedFields[$1] ?? false }
    }
    
    func isFieldUnlocked(_ field: String) -> Bool {
        unlockedFields[field] ?? false
    }
    
    func unlockField(_ field: String) {
        if unlockedFields.keys.contains(field) { // Only unlock if the field exists for this country
            unlockedFields[field] = true
        }
    }
    
    func getLockedFields() -> [String] {
        unlockedFields.filter { !$0.value }.map { $0.key }
    }
    
    func getUnlockedFields() -> [String] {
        unlockedFields.filter { $0.value }.map { $0.key }
    }
    
    func isFullyConquered() -> Bool {
        unlockedFields.allSatisfy { $0.value }
    }
}
