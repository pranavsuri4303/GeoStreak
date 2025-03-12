//
//  GeoStreakApp.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import SwiftUI
import SwiftData

@main
struct GeoStreakApp: App {
    // Track if we've initialized data
    @AppStorage("hasInitializedData") private var hasInitializedData = false
    
    // Create a persistent model container for SwiftData
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProgress.self,
            Country.self,
            CompletedChallenge.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
                .onAppear {
                    // Initialize data if this is the first launch
                    if !hasInitializedData {
                        let context = ModelContext(sharedModelContainer)
                        let dataManager = DataManager(context: context)
                        dataManager.initializeDatabase()
                        hasInitializedData = true
                        Logger.log("Initial data setup complete", level: .info)
                    }
                    Logger.log("App started", level: .info)
                }
        }
    }
}