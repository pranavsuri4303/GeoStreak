//
//  AppConstants.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//


import Foundation
import SwiftUI

/// App-wide constants
enum AppConstants {
    /// Number of countries per level
    static let countriesPerLevel = 5
    
    /// Maximum number of levels
    static let maxLevels = 10
    
    /// Default timer duration in seconds (for daily resets)
    static let timerDuration: TimeInterval = 86400 // 24 hours
    
    /// App color scheme
    enum Colors {
        static let primary = Color.blue
        static let secondary = Color.green
        static let accent = Color.orange
        static let background = Color(.systemBackground)
        static let secondaryBackground = Color(.secondarySystemBackground)
    }
    
    /// App UI metrics
    enum UI {
        static let cornerRadius: CGFloat = 12
        static let standardPadding: CGFloat = 16
        static let buttonHeight: CGFloat = 50
    }
    
    /// Notification names
    enum Notifications {
        static let dailyQuizReset = Notification.Name("com.geostreak.dailyQuizReset")
        static let levelCompleted = Notification.Name("com.geostreak.levelCompleted")
    }
}
