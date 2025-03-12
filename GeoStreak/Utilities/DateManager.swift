//
//  DateManager.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-19.
//

import Foundation

class DateManager {
    static let shared = DateManager()
    
    private init() {}
    
    // MARK: - Date Calculations
    
    /// Calculate the number of days between two dates
    func daysBetween(date1: Date, date2: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: date1), to: calendar.startOfDay(for: date2))
        return components.day ?? 0
    }
    
    /// Check if a date is today
    func isToday(_ date: Date) -> Bool {
        return Calendar.current.isDateInToday(date)
    }
    
    /// Get the start of today
    func startOfToday() -> Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    /// Get the start of tomorrow
    func startOfTomorrow() -> Date {
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else {
            return Date() // Fallback
        }
        return Calendar.current.startOfDay(for: tomorrow)
    }
    
    /// Format the time until next challenge
    func formatTimeUntilNext(from currentDate: Date, to targetDate: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: currentDate, to: targetDate)
        
        return String(format: "%02d:%02d:%02d",
                     components.hour ?? 0,
                     components.minute ?? 0,
                     components.second ?? 0)
    }
    
    /// Check if a user has maintained their streak based on last completed date
    func hasValidStreak(lastCompletedDate: Date?) -> Bool {
        guard let lastCompletedDate = lastCompletedDate else {
            return false // No previous completion, no streak
        }
        
        let days = daysBetween(date1: lastCompletedDate, date2: Date())
        
        // Streak is valid if they played today (0 days) or yesterday (1 day)
        return days <= 1
    }
    
    /// Determine if user is eligible for a new challenge today
    func isEligibleForChallenge(lastCompletedDate: Date?) -> Bool {
        guard let lastCompletedDate = lastCompletedDate else {
            return true // No previous completion, always eligible
        }
        
        // If user hasn't completed today's challenge, they're eligible
        return !Calendar.current.isDateInToday(lastCompletedDate)
    }
}