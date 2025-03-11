//
//  OnboardingPageType.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//


import SwiftUI

enum OnboardingPageType: Int, CaseIterable, Identifiable {
    case welcome
    case dailyChallenge
    case streakBuilding
    case levels
    case notifications
    case getStarted
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .welcome:
            return "Welcome to GeoStreak!"
        case .dailyChallenge:
            return "One Country Daily"
        case .streakBuilding:
            return "Build Your Streak"
        case .levels:
            return "Five Exciting Levels"
        case .notifications:
            return "Set Your Reminder Time"
        case .getStarted:
            return "Ready to Begin?"
        }
    }
    
    var description: String {
        switch self {
        case .welcome:
            return "A fun daily challenge to test your knowledge of world capitals"
        case .dailyChallenge:
            return "Each day, you'll be challenged with a country trivia. Make it count - you only get one guess!"
        case .streakBuilding:
            return "Keep answering correctly to build your streak and unlock new levels"
        case .levels:
            return "Journey through Europe, Asia, the Americas, Africa, and beyond"
        case .notifications:
            return "Choose when you'd like to be reminded to complete your daily challenge"
        case .getStarted:
            return "Your daily geography adventure starts now!"
        }
    }
    
    var imageName: String {
        switch self {
        case .welcome:
            return "globe"
        case .dailyChallenge:
            return "calendar.day.timeline.left"
        case .streakBuilding:
            return "flame.fill"
        case .levels:
            return "map.fill"
        case .notifications:
            return "bell.fill"
        case .getStarted:
            return "checkmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .welcome:
            return .blue
        case .dailyChallenge:
            return .orange
        case .streakBuilding:
            return .red
        case .levels:
            return .green
        case .notifications:
            return .yellow
        case .getStarted:
            return .purple
        }
    }
}

struct ReminderOption: Identifiable {
    let id = UUID()
    let name: String
    let hour: Int
    let description: String
    
    static let options: [ReminderOption] = [
        ReminderOption(name: "Morning 🌅", hour: 8, description: "Start your day with geography"),
        ReminderOption(name: "Midday ☀️", hour: 12, description: "Take a break with a quick challenge"),
        ReminderOption(name: "Evening 🌙", hour: 18, description: "Wind down with some geography")
    ]
}

enum NotificationPermissionStatus {
    case notDetermined
    case denied
    case granted
}
