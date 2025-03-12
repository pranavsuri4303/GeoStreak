//
//  StatsView.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                StatCard(title: "Current Streak",
                         value: "\(gameManager.userProgress.streak)",
                         icon: "flame.fill",
                         color: .orange)
                
                StatCard(title: "Longest Streak",
                         value: "\(gameManager.userProgress.longestStreak)",
                         icon: "crown.fill",
                         color: .yellow)
                
                StatCard(title: "Correct Answers",
                         value: "\(gameManager.userProgress.correctAnswers)",
                         icon: "checkmark.circle.fill",
                         color: .green)
                
                StatCard(title: "Accuracy",
                         value: calculateAccuracy(),
                         icon: "percent",
                         color: .blue)
                
                StatCard(title: "Current Level",
                         value: "\(gameManager.userProgress.currentLevel) - \(Level.allLevels.first { $0.id == gameManager.userProgress.currentLevel }?.name ?? "")",
                         icon: "map.fill",
                         color: .purple)
                
                StatCard(title: "Countries Mastered",
                         value: "\(gameManager.userProgress.completedCountries.count)",
                         icon: "globe",
                         color: .teal)
            }
            .padding()
            .navigationTitle(Text("Your Stats"))
        }
    }
    
    private func calculateAccuracy() -> String {
        let total = gameManager.userProgress.totalAnswers
        guard total > 0 else { return "0%" }
        
        let percentage = Double(gameManager.userProgress.correctAnswers) / Double(total) * 100
        return String(format: "%.1f%%", percentage)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
