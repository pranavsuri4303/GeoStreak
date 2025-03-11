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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProgress.self,
            Country.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true
        )

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}
