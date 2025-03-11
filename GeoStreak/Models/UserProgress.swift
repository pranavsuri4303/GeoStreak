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
}
