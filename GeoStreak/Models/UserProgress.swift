//
//  UserProgress.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import Foundation
import SwiftData

@Model
final class UserProgress {
    var streak: Int
    var longestStreak: Int
    var correctAnswers: Int
    var totalAnswers: Int
    var lastCompletedDate: Date?
    var currentLevel: Int
    var hasCompletedOnboarding: Bool
    var preferredReminderHour: Int = 8
    @Relationship(deleteRule: .cascade) var completedCountries: [Country] = []
    @Relationship(deleteRule: .cascade) var completedChallenges: [CompletedChallenge] = []
    
    init(streak: Int = 0,
         longestStreak: Int = 0,
         correctAnswers: Int = 0,
         totalAnswers: Int = 0,
         lastCompletedDate: Date? = nil,
         currentLevel: Int = 1,
         hasCompletedOnboarding: Bool = false,
         preferredReminderHour: Int = 8) {
        self.streak = streak
        self.longestStreak = longestStreak
        self.correctAnswers = correctAnswers
        self.totalAnswers = totalAnswers
        self.lastCompletedDate = lastCompletedDate
        self.currentLevel = currentLevel
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.preferredReminderHour = preferredReminderHour
    }
    
    // Check if a country is completed
    func isCountryCompleted(name: String) -> Bool {
        return completedCountries.contains(where: { $0.name == name })
    }
    
    // Mark a country as completed
    func markCountryCompleted(_ country: Country) {
        if !isCountryCompleted(name: country.name) {
            country.isCompleted = true
            completedCountries.append(country)
        }
    }
    
    // Check if a specific challenge for a country is completed
    func isChallengeCompleted(countryName: String, challengeType: DailyChallengeType) -> Bool {
        return completedChallenges.contains(where: {
            $0.countryName == countryName && $0.challengeTypeId == challengeType.id
        })
    }
    
    // Mark a specific challenge as completed
    func markChallengeCompleted(countryName: String, challengeType: DailyChallengeType) {
        if !isChallengeCompleted(countryName: countryName, challengeType: challengeType) {
            let challenge = CompletedChallenge(
                countryName: countryName,
                challengeTypeId: challengeType.id
            )
            completedChallenges.append(challenge)
        }
    }
    
    // Calculate the completion percentage for a level
    func completionPercentage(for level: Int) -> Double {
        let totalChallengesInLevel = completedChallenges.filter { challenge in
            // Find the country this challenge belongs to
            let country = completedCountries.first { $0.name == challenge.countryName }
            // Check if it's in the requested level
            return country?.level == level
        }.count
        
        // Each country has 3 possible challenges (one for each challenge type)
        let potentialChallengesInLevel = countCountriesInLevel(level) * DailyChallengeType.allCases.count
        
        guard potentialChallengesInLevel > 0 else { return 0 }
        
        return Double(totalChallengesInLevel) / Double(potentialChallengesInLevel)
    }
    
    // Count the number of countries in a specific level
    private func countCountriesInLevel(_ level: Int) -> Int {
        return completedCountries.filter { $0.level == level }.count
    }
}
