//
//  LevelsView.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import SwiftUI
import Foundation

struct LevelsView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(Level.allLevels) { level in
                        LevelCard(
                            level: level,
                            isUnlocked: gameManager.userProgress.currentLevel >= level.id,
                            isCurrent: gameManager.userProgress.currentLevel == level.id,
                            progress: calculateProgress(for: level.id)
                        )
                    }
                }
                .padding()
                .navigationTitle("Your Journey")
                .toolbar {
                    Button("Hello") {
                        print("Hello World")
                    }
                }
            }
        }
    }
    
    private func calculateProgress(for levelId: Int) -> Double {
        let countriesInLevel: Int = levelId == gameManager.userProgress.currentLevel ?
            gameManager.userProgress.completedCountries.count :
            (levelId < gameManager.userProgress.currentLevel ? 5 : 0)
        
        return Double(countriesInLevel) / 5.0
    }
}
