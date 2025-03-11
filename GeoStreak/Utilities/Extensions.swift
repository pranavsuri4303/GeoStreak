//
//  Extensions.swift
//  GeoStreak
//
//  Created by Pranav Suri
//

import Foundation
import SwiftUI

// MARK: - Color Extensions
extension Color {
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
}

// MARK: - String Extensions
extension String {
    func capitalized() -> String {
        return self.prefix(1).uppercased() + self.dropFirst().lowercased()
    }
    
    func normalized() -> String {
        return self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color.secondaryBackground)
            .cornerRadius(10)
            .shadow(radius: 1)
    }
}

// MARK: - Date Extensions
extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
}