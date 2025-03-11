//
//  CountryRepository.swift
//  GeoStreak
//
//  Created by Pranav Suri
//

import Foundation
import SwiftData

class CountryRepository {
    private let modelContext: ModelContext
    
    init(context: ModelContext) {
        self.modelContext = context
        ensureCountriesExist()
    }
    
    // MARK: - Data Management
    
    /// Ensures that countries exist in the database
    private func ensureCountriesExist() {
        do {
            let descriptor = FetchDescriptor<Country>()
            let existingCountries = try modelContext.fetch(descriptor)
            
            if existingCountries.isEmpty {
                for country in Country.sampleCountries {
                    modelContext.insert(country)
                }
                try modelContext.save()
            }
        } catch {
            print("Failed to check countries: \(error)")
        }
    }
    
    /// Get all countries
    func getAllCountries() -> [Country] {
        do {
            let descriptor = FetchDescriptor<Country>(sortBy: [SortDescriptor(\Country.name)])
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch countries: \(error)")
            return []
        }
    }
    
    /// Get countries for a specific level
    func getCountriesForLevel(_ level: Int) -> [Country] {
        do {
            let descriptor = FetchDescriptor<Country>(
                predicate: #Predicate<Country> { $0.level == level },
                sortBy: [SortDescriptor(\Country.name)]
            )
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch countries for level \(level): \(error)")
            return []
        }
    }
    
    /// Get countries for a specific continent
    func getCountriesForContinent(_ continent: String) -> [Country] {
        do {
            let descriptor = FetchDescriptor<Country>(
                predicate: #Predicate<Country> { $0.continent == continent },
                sortBy: [SortDescriptor(\Country.name)]
            )
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch countries for continent \(continent): \(error)")
            return []
        }
    }
    
    /// Get uncompleted countries for a level
    func getUncompletedCountriesForLevel(_ level: Int) -> [Country] {
        do {
            let descriptor = FetchDescriptor<Country>(
                predicate: #Predicate<Country> { $0.level == level && !$0.isCompleted },
                sortBy: [SortDescriptor(\Country.name)]
            )
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch uncompleted countries for level \(level): \(error)")
            return []
        }
    }
    
    /// Mark a country as completed
    func markCountryCompleted(_ country: Country) {
        country.isCompleted = true
        do {
            try modelContext.save()
        } catch {
            print("Failed to save country completion: \(error)")
        }
    }
    
    /// Get a random country for a specific level
    func getRandomCountryForLevel(_ level: Int) -> Country? {
        let countries = getUncompletedCountriesForLevel(level)
        return countries.randomElement()
    }
    
    /// Check if all countries in a level are completed
    func areAllCountriesCompletedForLevel(_ level: Int) -> Bool {
        return getUncompletedCountriesForLevel(level).isEmpty
    }
    
    /// Reset completion status for all countries
    func resetAllCountriesCompletion() {
        let countries = getAllCountries()
        for country in countries {
            country.isCompleted = false
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to reset countries: \(error)")
        }
    }
    
    /// Add new countries to the database
    func addNewCountries(_ countries: [Country]) {
        for country in countries {
            modelContext.insert(country)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to add new countries: \(error)")
        }
    }
}
