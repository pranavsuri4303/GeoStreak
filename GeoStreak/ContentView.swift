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
    @StateObject private var gameManager: GameManager
    
    init() {
        // Initialize the GameManager with a temporary context
        // The actual context will be injected via the Environment
        self._gameManager = StateObject(wrappedValue: GameManager(context: ModelContext(try! ModelContainer(for: Country.self, UserProgress.self))))
    }
    
    var body: some View {
        Group {
            if gameManager.isLoading {
                LoadingView()
            } else {
                MainTabView()
                    .environmentObject(gameManager)
            }
        }
        .onAppear {
            // Update the model context with the one from the environment
            gameManager.updateModelContext(modelContext)
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var showDailyChallenge = false
    
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
        .fullScreenCover(isPresented: $gameManager.showOnboarding) {
            OnboardingView(coordinator: OnboardingCoordinator(gameManager: gameManager))
                .environmentObject(gameManager)
        }
        .fullScreenCover(isPresented: $showDailyChallenge) {
            DailyQuizView()
                .environmentObject(gameManager)
        }
        .onAppear {
            // Check if we need to show the daily challenge
            if !gameManager.hasTodaysAnswer && !gameManager.showOnboarding {
                showDailyChallenge = true
            }
        }
    }
}