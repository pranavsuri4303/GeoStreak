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
                let countries = try await loadAllCountries()
                isInitialized = true
                logInfo("CountryService initialized with \(countries.count) countries", category: Logger.data)
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
        
        // Locate the JSON file
        guard let url = Bundle.main.url(forResource: "CountryData", withExtension: "json") else {
            logError("Failed to find CountryData.json in bundle", category: Logger.data)
            throw ServiceError.resourceNotFound
        }
        
        do {
            // Load and decode the data
            let data = try Data(contentsOf: url)
            
            // Check if data is empty
            guard !data.isEmpty else {
                logError("CountryData.json is empty", category: Logger.data)
                throw ServiceError.decodingFailed
            }
            
            // Decode the data
            let decoder = JSONDecoder()
            do {
                let countries = try decoder.decode([CountryData].self, from: data)
                logInfo("Successfully loaded \(countries.count) countries", category: Logger.data)
                countriesCache = countries
                return countries
            } catch {
                logError("Failed to decode country data: \(error)", category: Logger.data)
                throw ServiceError.decodingFailed
            }
        } catch {
            if !(error is ServiceError) {
                logError("Failed to load country data: \(error.localizedDescription)", category: Logger.data)
            }
            throw error
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
        let filtered = countries.filter { $0.continent == continent }
        logDebug("Found \(filtered.count) countries in \(continent)", category: Logger.data)
        return filtered
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
        logInfo("Countries cache cleared", category: Logger.data)
    }
    
    /// Errors that can occur in the service
    enum ServiceError: Error {
        case resourceNotFound
        case decodingFailed
    }
}
