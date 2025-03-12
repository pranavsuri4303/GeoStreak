//
//  UserProgressService.swift
//  GeoStreak
//
//  Created for improved data handling
//

import Foundation
import SwiftData
import OSLog

/// Service responsible for managing user progress with SwiftData
actor UserProgressService {
    private let modelContainer: ModelContainer
    private let countryService: CountryService
    
    /// Initializes the service with the SwiftData model container
    /// - Parameter modelContainer: The app's SwiftData model container
    init(modelContainer: ModelContainer, countryService: CountryService) {
        self.modelContainer = modelContainer
        self.countryService = countryService
    }
    
    /// Gets or creates progress for a specific country
    /// - Parameter countryId: The country ID
    /// - Returns: CountryProgress for the given country
    func getOrCreateProgress(for countryId: String) async throws -> CountryProgress {
        return try await Task.detached(priority: .userInitiated) { [modelContainer, countryService] in
            let context = await modelContainer.mainContext
            
            // Try to find existing progress
            let descriptor = FetchDescriptor<CountryProgress>(
                predicate: #Predicate { $0.countryId == countryId }
            )
            
            if let existingProgress = try context.fetch(descriptor).first {
                return existingProgress
            }
            
            // Create new progress if none exists
            // Get available fields from country data
            guard let country = try await countryService.getCountry(byId: countryId) else {
                logError("Country not found with ID: \(countryId)", category: Logger.data)
                throw ProgressError.countryNotFound
            }
            
            let availableFields = country.answerableFieldKeys
            let newProgress = CountryProgress(countryId: countryId, availableFields: availableFields)
            
            context.insert(newProgress)
            try context.save()
            logInfo("Created new progress for country: \(countryId)", category: Logger.data)
            
            return newProgress
        }.value
    }
    
    /// Checks if a specific field for a country is unlocked
    /// - Parameters:
    ///   - field: The field name to check (e.g., "capital", "name")
    ///   - countryId: The country ID
    /// - Returns: True if the field is unlocked, false otherwise
    func isFieldUnlocked(_ field: String, for countryId: String) async throws -> Bool {
        let progress = try await getOrCreateProgress(for: countryId)
        return progress.isFieldUnlocked(field)
    }
    
    /// Unlocks a specific field for a country
    /// - Parameters:
    ///   - field: The field name to unlock
    ///   - countryId: The country ID
    func unlockField(_ field: String, for countryId: String) async throws {
        try await Task.detached(priority: .userInitiated) { [modelContainer] in
            let context = await modelContainer.mainContext
            
            let descriptor = FetchDescriptor<CountryProgress>(
                predicate: #Predicate { $0.countryId == countryId }
            )
            
            guard let progress = try context.fetch(descriptor).first else {
                logError("Progress not found for country: \(countryId)", category: Logger.data)
                throw ProgressError.progressNotFound
            }
            
            progress.unlockField(field)
            try context.save()
            logInfo("Unlocked field '\(field)' for country: \(countryId)", category: Logger.data)
        }.value
    }
    
    /// Gets all unlocked fields for a country
    /// - Parameter countryId: The country ID
    /// - Returns: Array of unlocked field names
    func getUnlockedFields(for countryId: String) async throws -> [String] {
        let progress = try await getOrCreateProgress(for: countryId)
        return progress.getUnlockedFields()
    }
    
    /// Gets all locked fields for a country
    /// - Parameter countryId: The country ID
    /// - Returns: Array of locked field names
    func getLockedFields(for countryId: String) async throws -> [String] {
        let progress = try await getOrCreateProgress(for: countryId)
        return progress.getLockedFields()
    }
    
    /// Checks if a country is fully conquered (all fields unlocked)
    /// - Parameter countryId: The country ID
    /// - Returns: True if all fields are unlocked, false otherwise
    func isCountryFullyConquered(countryId: String) async throws -> Bool {
        let progress = try await getOrCreateProgress(for: countryId)
        return progress.isFullyConquered()
    }
    
    /// Gets a list of all conquered countries
    /// - Returns: Array of country IDs that are fully conquered
    func getConqueredCountries() async throws -> [String] {
        return try await Task.detached(priority: .userInitiated) { [modelContainer] in
            let context = await modelContainer.mainContext
            let descriptor = FetchDescriptor<CountryProgress>()
            let allProgress = try context.fetch(descriptor)
            
            let conqueredCountries = allProgress.filter { $0.isFullyConquered() }.map { $0.countryId }
            logInfo("Found \(conqueredCountries.count) fully conquered countries", category: Logger.data)
            return conqueredCountries
        }.value
    }
    
    /// Gets a filtered view of country data based on unlock status
    /// - Parameter countryId: The country ID
    /// - Returns: A tuple containing the country data and a dictionary of field visibility
    func getFilteredCountryData(for countryId: String) async throws -> (country: CountryData, visibleFields: [String: Bool]) {
        async let countryTask = countryService.getCountry(byId: countryId)
        async let progressTask = getOrCreateProgress(for: countryId)
        
        guard let country = try await countryTask else {
            logError("Failed to get country data for ID: \(countryId)", category: Logger.data)
            throw ProgressError.countryNotFound
        }
        
        let progress = try await progressTask
        let unlockedFields = progress.getUnlockedFields()
        
        var visibleFields: [String: Bool] = [:]
        for field in country.answerableFieldKeys {
            visibleFields[field] = unlockedFields.contains(field)
        }
        
        logDebug("Retrieved filtered country data for \(countryId) with \(unlockedFields.count) unlocked fields", category: Logger.data)
        return (country: country, visibleFields: visibleFields)
    }
    
    /// Errors that can occur in the progress service
    enum ProgressError: Error {
        case countryNotFound
        case progressNotFound
    }
}
