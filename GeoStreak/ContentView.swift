//
//  ContentView.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var gameManager = GameManager()
    
    var body: some View {
        Group {
            if gameManager.isLoading {
                LoadingView()
            } else {
                MainTabView()
                    .environmentObject(gameManager)
                    .fullScreenCover(isPresented: $gameManager.showDailyChallenge) {
                        DailyChallengeView(gameManager: gameManager)
                    }
                    .fullScreenCover(isPresented: $gameManager.showOnboarding) {
                        OnboardingView(coordinator: OnboardingCoordinator(gameManager: gameManager))
                    }
            }
        }
        .onAppear {
            gameManager.updateModelContext(modelContext)
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        TabView {
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
            
            LevelsView()
                .tabItem {
                    Label("Levels", systemImage: "map.fill")
                }
        }
        .accentColor(AppConstants.Colors.primary)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Country.self, UserProgress.self, CompletedChallenge.self], inMemory: true)
}
