//
//  CountryService.swift
//  GeoStreak
//
//  Created for improved data handling
//

import Foundation
import OSLog

/// Service responsible for providing country data from JSON source
actor CountryService {
    // Singleton instance
    static let shared = CountryService()
    
    // Cache of loaded countries to avoid repeated JSON parsing
    private var countriesCache: [CountryData]?
    
    // Boolean to track if initial loading has been completed
    private var isInitialized = false
    
    /// Preloads country data in the background
    func initialize() async {
        if !isInitialized {
            do {
                _ = try await loadAllCountries()
                isInitialized = true
                print(self.countriesCache?.count ?? 0)
                logInfo("CountryService initialized successfully with \(self.countriesCache?.count ?? 0) countries", category: Logger.data)
            } catch {
                logError("CountryService initialization failed: \(error.localizedDescription)", category: Logger.data)
            }
        }
    }
    
    /// Loads all countries from the bundled JSON file
    /// - Returns: Array of CountryData objects
    func loadAllCountries() async throws -> [CountryData] {
        // Return cached data if available
        if let cached = countriesCache {
            return cached
        }
        
        // Load the data without using Task.detached
        guard let url = Bundle.main.url(forResource: "CountryData", withExtension: "json") else {
            logError("Failed to find CountryData.json in bundle", category: Logger.data)
            throw ServiceError.resourceNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let countries = try decoder.decode([CountryData].self, from: data)
            countriesCache = countries
            return countries
        } catch {
            logError("Failed to decode country data: \(error.localizedDescription)", category: Logger.data)
            throw ServiceError.decodingFailed
        }
    }
    
    /// Gets country by its ID
    /// - Parameter id: Country ID (e.g. "US", "CA")
    /// - Returns: CountryData if found, nil otherwise
    func getCountry(byId id: String) async throws -> CountryData? {
        let countries = try await loadAllCountries()
        return countries.first { $0.id == id }
    }
    
    /// Gets countries filtered by continent
    /// - Parameter continent: Continent name
    /// - Returns: Array of countries in the specified continent
    func getCountries(byContinent continent: String) async throws -> [CountryData] {
        let countries = try await loadAllCountries()
        return countries.filter { $0.continent == continent }
    }
    
    /// Gets countries sorted by difficulty level
    /// - Returns: Countries sorted by their level property
    func getCountriesByLevel() async throws -> [CountryData] {
        let countries = try await loadAllCountries()
        return countries.sorted { $0.level < $1.level }
    }
    
    /// Gets all continents from the country data
    /// - Returns: Array of unique continent names
    func getAllContinents() async throws -> [String] {
        let countries = try await loadAllCountries()
        return Array(Set(countries.map { $0.continent })).sorted()
    }
    
    /// Clears the countries cache
    func clearCache() {
        countriesCache = nil
        isInitialized = false
    }
    
    /// Errors that can occur in the service
    enum ServiceError: Error {
        case resourceNotFound
        case decodingFailed
    }
}
