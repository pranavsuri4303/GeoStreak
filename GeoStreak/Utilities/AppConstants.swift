//
//  AppConstants.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import Foundation
import SwiftUI

struct AppConstants {
    // MARK: - Game Settings
    struct Game {
        static let maxLevel = 5
        static let countriesPerLevel = 15
        static let initialLevel = 1
        static let daysToBreakStreak = 1
        static let levelProgressionThreshold = 0.6 // 60% completion required to unlock next level
        static let dailyChallengeTypes = DailyChallengeType.allCases
        static let maxDailyChallengesPerDay = 1    }
    
    // MARK: - Typography
    struct Typography {
        // Font sizes
        static let flagSize: CGFloat = 100
        static let largeTitle: CGFloat = 34
        static let title1: CGFloat = 28
        static let title2: CGFloat = 22
        static let title3: CGFloat = 20
        static let headline: CGFloat = 17
        static let body: CGFloat = 17
        static let callout: CGFloat = 16
        static let subheadline: CGFloat = 15
        static let footnote: CGFloat = 13
        static let caption1: CGFloat = 12
        static let caption2: CGFloat = 11
        
        // Font styles
        static func largeTitle(_ weight: Font.Weight = .bold) -> Font {
            return .system(size: largeTitle, weight: weight, design: .default)
        }
        
        static func title1(_ weight: Font.Weight = .bold) -> Font {
            return .system(size: title1, weight: weight, design: .default)
        }
        
        static func title2(_ weight: Font.Weight = .bold) -> Font {
            return .system(size: title2, weight: weight, design: .default)
        }
        
        static func title3(_ weight: Font.Weight = .semibold) -> Font {
            return .system(size: title3, weight: weight, design: .default)
        }
        
        static func headline(_ weight: Font.Weight = .semibold) -> Font {
            return .system(size: headline, weight: weight, design: .default)
        }
        
        static func body(_ weight: Font.Weight = .regular) -> Font {
            return .system(size: body, weight: weight, design: .default)
        }
        
        static func callout(_ weight: Font.Weight = .regular) -> Font {
            return .system(size: callout, weight: weight, design: .default)
        }
        
        static func subheadline(_ weight: Font.Weight = .regular) -> Font {
            return .system(size: subheadline, weight: weight, design: .default)
        }
        
        static func footnote(_ weight: Font.Weight = .regular) -> Font {
            return .system(size: footnote, weight: weight, design: .default)
        }
        
        static func caption1(_ weight: Font.Weight = .regular) -> Font {
            return .system(size: caption1, weight: weight, design: .default)
        }
        
        static func caption2(_ weight: Font.Weight = .regular) -> Font {
            return .system(size: caption2, weight: weight, design: .default)
        }
    }
    
    // MARK: - Colors
    struct Colors {
        // Primary colors
        static let primary = Color.blue
        static let secondary = Color.green
        static let accent = Color.orange
        
        // Semantic colors
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        static let info = Color.blue
        
        // Level colors
        static let level1 = Color.blue
        static let level2 = Color.red
        static let level3 = Color.green
        static let level4 = Color.orange
        static let level5 = Color.purple
        
        // Background colors
        static let background = Color(UIColor.systemBackground)
        static let secondaryBackground = Color(UIColor.secondarySystemBackground)
        static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
        
        // Text colors
        static let primaryText = Color(UIColor.label)
        static let secondaryText = Color(UIColor.secondaryLabel)
        static let tertiaryText = Color(UIColor.tertiaryLabel)
    }
    
    // MARK: - Layout
    struct Layout {
        // Spacing
        static let xxxSmall: CGFloat = 2
        static let xxSmall: CGFloat = 4
        static let xSmall: CGFloat = 8
        static let small: CGFloat = 12
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
        static let xxLarge: CGFloat = 48
        
        // Radii
        static let smallRadius: CGFloat = 6
        static let mediumRadius: CGFloat = 12
        static let largeRadius: CGFloat = 16
        static let circleRadius: CGFloat = 999
        
        // Component sizes
        static let buttonHeight: CGFloat = 50
        static let iconSize: CGFloat = 24
        static let smallIconSize: CGFloat = 16
        static let largeIconSize: CGFloat = 32
        
        // Padding
        static let screenPadding: CGFloat = 16
        static let cardPadding: CGFloat = 16
        
        // Animations
        static let defaultAnimation = Animation.easeInOut(duration: 0.3)
        static let quickAnimation = Animation.easeOut(duration: 0.15)
    }
    
    // MARK: - UI Constants
    struct UI {
        // Corner radius
        static let cornerRadius: CGFloat = Layout.mediumRadius
        static let standardPadding: CGFloat = Layout.medium
        
        // Shadow properties
        static let shadowRadius: CGFloat = 5
        static let shadowOpacity: CGFloat = 0.1
        
        // Button styles
        struct Button {
            static let primaryBackground = Colors.primary
            static let primaryForeground = Color.white
            static let secondaryBackground = Colors.secondaryBackground
            static let secondaryForeground = Colors.primaryText
            static let disabledBackground = Color.gray.opacity(0.3)
            static let disabledForeground = Color.gray
        }
        
        // Card styles
        struct Card {
            static let background = Colors.secondaryBackground
            static let border = Color.gray.opacity(0.2)
            static let borderWidth: CGFloat = 1
        }
    }
    
    // MARK: - Notifications
    struct Notifications {
        static let reminderTitle = "Daily Challenge Reminder"
        static let reminderBody = "Don't forget to complete your daily geography challenge!"
        static let defaultHour = 9
        static let scheduleDays = 365
        static let categoryIdentifier = "dailyChallenge"
        static let notificationPermissionTitle = "Get Daily Reminders"
        static let notificationPermissionMessage = "We'll send you a friendly reminder to complete your daily challenge at your preferred time."
    }
    
    // MARK: - Error Messages
    struct ErrorMessages {
        static let dataLoadingError = "Failed to load data. Please try again later."
        static let networkError = "Network connection unavailable. Please check your connection."
        static let generalError = "Something went wrong. Please try again."
        static let incorrectAnswer = "That's not the correct capital. Try again tomorrow!"
        static let emptyAnswer = "Please enter your answer before submitting."
    }
    
    // MARK: - String Constants
    struct Text {
        // App general
        static let appTitle = "GeoStreak"
        static let loading = "Loading..."
        static let retry = "Retry"
        
        // Stats
        static let streakLabel = "Current Streak"
        static let highestStreakLabel = "Highest Streak"
        static let correctAnswersLabel = "Correct Answers"
        static let totalAnswersLabel = "Total Answers"
        static let accuracyLabel = "Accuracy"
        static let nextChallengeLabel = "Next Challenge"
        
        // Actions
        static let submitAnswer = "Submit Answer"
        static let tryAgain = "Try Again"
        static let close = "Close"
        static let continueButton = "Continue"
        static let skipButton = "Skip"
        static let nextButton = "Next"
        static let backButton = "Back"
        static let doneButton = "Done"
        
        // Challenge
        static let dailyChallenge = "Daily Challenge"
        static let whatIsCapital = "What is the capital of"
        static let enterCapital = "Enter capital city"
        static let correctAnswer = "Correct!"
        static let incorrectAnswer = "Incorrect"
        static let comeBackTomorrow = "Come back tomorrow for a new challenge!"
        
        // Levels
        static let levels = "Levels"
        static let level = "Level"
        static let progress = "Progress"
        static let completed = "Completed"
        static let locked = "Locked"
        
        // Settings
        static let settings = "Settings"
        static let notificationTime = "Notification Time"
        static let resetProgress = "Reset Progress"
        static let about = "About"
    }
}
