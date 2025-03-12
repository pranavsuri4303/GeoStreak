//
//  DailyChallengeType.swift
//  GeoStreak
//
//  Created by Pranav Suri
//

import Foundation
import SwiftUI

/// Represents different types of daily challenges in the app
enum DailyChallengeType: CaseIterable, Identifiable {
    case flagToCountry     // Flag displayed, guess country name
    case countryToCapital  // Country name displayed with flag, guess capital
    case flagToCapital     // Flag displayed, guess capital
    
    /// Unique identifier for each challenge type
    var id: String {
        switch self {
        case .flagToCountry: return "flag-to-country"
        case .countryToCapital: return "country-to-capital"
        case .flagToCapital: return "flag-to-capital"
        }
    }
    
    /// The prompt question to display to the user
    var prompt: String {
        switch self {
        case .flagToCountry:
            return "What country does this flag belong to?"
        case .countryToCapital:
            return "What is the capital of this country?"
        case .flagToCapital:
            return "What is the capital city of the country this flag belongs to?"
        }
    }
    
    /// The expected answer type
    var answerType: String {
        switch self {
        case .flagToCountry:
            return "Country"
        case .countryToCapital, .flagToCapital:
            return "Capital"
        }
    }
    
    /// The placeholder text for the answer input field
    var inputPlaceholder: String {
        switch self {
        case .flagToCountry:
            return "Enter country name..."
        case .countryToCapital, .flagToCapital:
            return "Enter capital city..."
        }
    }
    
    /// Get the expected answer from a country based on the challenge type
    func getExpectedAnswer(from country: Country) -> String {
        switch self {
        case .flagToCountry:
            return country.name
        case .countryToCapital, .flagToCapital:
            return country.capital
        }
    }
    
    /// Validates whether the given answer is correct for this challenge type and country
    func validateAnswer(_ answer: String, for country: Country) -> Bool {
        let expectedAnswer = getExpectedAnswer(from: country)
        let normalizedAnswer = answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedExpected = expectedAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        return normalizedAnswer == normalizedExpected
    }
}

/// Extension to add color and icon properties for UI presentation
extension DailyChallengeType {
    var color: Color {
        switch self {
        case .flagToCountry:
            return AppConstants.Colors.primary
        case .countryToCapital:
            return AppConstants.Colors.secondary
        case .flagToCapital:
            return AppConstants.Colors.accent
        }
    }
    
    var icon: String {
        switch self {
        case .flagToCountry:
            return "flag.fill"
        case .countryToCapital:
            return "building.columns.fill"
        case .flagToCapital:
            return "mappin.and.ellipse"
        }
    }
}
