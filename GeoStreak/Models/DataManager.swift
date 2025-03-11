//
//  DataManager 2.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//


import Foundation
import SwiftData

/// Class responsible for data initialization and management
class DataManager {
    private let modelContext: ModelContext
    
    init(context: ModelContext) {
        self.modelContext = context
    }
    
    /// Initialize the database with required data
    func initializeDatabase() {
        ensureUserProgressExists()
        ensureCountriesExist()
    }
    
    private func ensureUserProgressExists() {
        do {
            let descriptor = FetchDescriptor<UserProgress>()
            let existingProgress = try modelContext.fetch(descriptor)
            
            if existingProgress.isEmpty {
                let progress = UserProgress()
                modelContext.insert(progress)
                try modelContext.save()
            }
        } catch {
            print("Error ensuring user progress exists: \(error)")
        }
    }
    
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
            print("Error ensuring countries exist: \(error)")
        }
    }
    
    /// Reset the database (useful for debugging)
    func resetDatabase() {
        do {
            try modelContext.delete(model: UserProgress.self)
            try modelContext.delete(model: Country.self)
            
            // Re-initialize database
            initializeDatabase()
        } catch {
            print("Error resetting database: \(error)")
        }
    }
    
    /// Import countries from a JSON file
    func importCountriesFromJSON(_ jsonURL: URL) {
        do {
            let data = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            let countries = try decoder.decode([CountryDTO].self, from: data)
            
            // Convert DTOs to model objects
            for countryDTO in countries {
                let country = Country(
                    name: countryDTO.name,
                    capital: countryDTO.capital,
                    level: countryDTO.level,
                    flag: countryDTO.flag,
                    funFact: countryDTO.funFact,
                    continent: countryDTO.continent,
                    difficulty: countryDTO.difficulty
                )
                modelContext.insert(country)
            }
            
            try modelContext.save()
        } catch {
            print("Error importing countries from JSON: \(error)")
        }
    }
}

// Data Transfer Object for importing countries
struct CountryDTO: Codable {
    let name: String
    let capital: String
    let level: Int
    let flag: String
    let funFact: String
    let continent: String
    let difficulty: Int
}
