//  GameManager.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import Foundation
import SwiftData
import Combine

// MARK: - Game Logic
class GameManager: ObservableObject {
    @Published var userProgress: UserProgress
    @Published var todaysCountry: Country?
    @Published var todaysChallengeType: DailyChallengeType?
    @Published var hasTodaysAnswer = false
    @Published var timeUntilNextChallenge = ""
    @Published var showOnboarding = false
    @Published var isLoading = true
    @Published var showDailyChallenge = false
    
    private var modelContext: ModelContext
    private var countryRepository: CountryRepository
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        self.modelContext = ModelContext(try! ModelContainer(for: Country.self, UserProgress.self, CompletedChallenge.self))
        self.countryRepository = CountryRepository(context: self.modelContext)
        self.userProgress = UserProgress()
        self.isLoading = true
        loadUserProgress()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Data Loading
    
    private func loadUserProgress() {
        do {
            let descriptor = FetchDescriptor<UserProgress>()
            let existingProgress = try modelContext.fetch(descriptor)
            
            if let progress = existingProgress.first {
                self.userProgress = progress
                self.showOnboarding = !progress.hasCompletedOnboarding
            } else {
                self.userProgress = UserProgress()
                self.showOnboarding = true
                modelContext.insert(self.userProgress)
                try modelContext.save()
            }
            
            // Check streak continuity on app start
            checkStreakContinuity()
            
            // Check if there's a daily challenge available
            checkDailyChallengeAvailability()
            
            startTimer()
            isLoading = false
        } catch {
            Logger.log("Error loading user progress: \(error)", level: .error)
            startTimer()
            isLoading = false
        }
    }
    
    func updateModelContext(_ context: ModelContext) {
        self.modelContext = context
        self.countryRepository = CountryRepository(context: context)
        loadUserProgress()
    }
    
    private func saveProgress() {
        do {
            try modelContext.save()
        } catch {
            Logger.log("Error saving progress: \(error)", level: .error)
        }
    }
    
    // MARK: - Daily Challenge Availability
    
    func checkDailyChallengeAvailability() {
        // Don't show challenge during onboarding
        if showOnboarding {
            showDailyChallenge = false
            return
        }
        
        // Check if user already completed today's challenge
        if let lastDate = userProgress.lastCompletedDate,
           DateManager.shared.isToday(lastDate) {
            hasTodaysAnswer = true
            showDailyChallenge = false
            return
        }
        
        hasTodaysAnswer = false
        showDailyChallenge = true
    }
    
    // MARK: - Challenge Selection
    
    func fetchTodaysChallenge() {
        // Select a random challenge type
        todaysChallengeType = DailyChallengeType.allCases.randomElement()
        
        // Choose an appropriate country based on user's level
        fetchRandomCountryForChallenge()
    }
    
    private func fetchRandomCountryForChallenge() {
        // Get countries from current level
        let availableCountries = getAvailableCountriesForChallenge()
        
        if availableCountries.isEmpty {
            handleNoAvailableCountries()
            return
        }
        
        // Choose a random country
        todaysCountry = availableCountries.randomElement()
    }
    
    private func getAvailableCountriesForChallenge() -> [Country] {
        guard let challengeType = todaysChallengeType else {
            return []
        }
        
        // Get countries from current level
        let currentLevelCountries = countryRepository.getCountriesForLevel(userProgress.currentLevel)
        
        // If user has progressed enough, also include some countries from the next level
        var availableCountries = currentLevelCountries
        
        // Check if we should include next level countries (if completion is above 60%)
        if userProgress.completionPercentage(for: userProgress.currentLevel) >= AppConstants.Game.levelProgressionThreshold &&
            userProgress.currentLevel < AppConstants.Game.maxLevel {
            
            let nextLevelCountries = countryRepository.getCountriesForLevel(userProgress.currentLevel + 1)
            availableCountries.append(contentsOf: nextLevelCountries)
        }
        
        // Filter out countries that have already been answered for this challenge type
        return availableCountries.filter { country in
            return !userProgress.isChallengeCompleted(
                countryName: country.name,
                challengeType: challengeType
            )
        }
    }
    
    private func handleNoAvailableCountries() {
        // Reset challenges for current level if all have been completed
        // and move to next level if appropriate
        if userProgress.completionPercentage(for: userProgress.currentLevel) >= AppConstants.Game.levelProgressionThreshold &&
            userProgress.currentLevel < AppConstants.Game.maxLevel {
            userProgress.currentLevel += 1
        } else {
            // Reset completed challenges for the current level to start fresh
            resetCompletedChallengesForLevel(userProgress.currentLevel)
        }
        
        // Try fetching again
        fetchRandomCountryForChallenge()
    }
    
    private func resetCompletedChallengesForLevel(_ level: Int) {
        // Get list of countries in the level
        let countriesInLevel = countryRepository.getCountriesForLevel(level)
        let countryNames = countriesInLevel.map { $0.name }
        
        // Remove completed challenges for these countries
        userProgress.completedChallenges.removeAll { challenge in
            return countryNames.contains(challenge.countryName)
        }
    }
    
    // MARK: - Streak Management
    
    private func checkStreakContinuity() {
        guard let lastCompletedDate = userProgress.lastCompletedDate else {
            // No previous completion, no streak to check
            return
        }
        
        let daysBetween = DateManager.shared.daysBetween(date1: lastCompletedDate, date2: Date())
        
        // If more than 1 day has passed, break the streak
        if daysBetween > 1 {
            Logger.log("Streak reset: \(daysBetween) days since last play", level: .info)
            userProgress.streak = 0
            saveProgress()
        }
    }
    
    // MARK: - Game Actions
    
    func verifyAnswer(country: Country, challengeType: DailyChallengeType, guess: String) -> Bool {
        return challengeType.validateAnswer(guess, for: country)
    }
    
    func submitAnswer(guess: String, isCorrect: Bool) {
        guard let country = todaysCountry,
              let challengeType = todaysChallengeType,
              !hasTodaysAnswer else {
            return
        }
        
        userProgress.totalAnswers += 1
        hasTodaysAnswer = true
        userProgress.lastCompletedDate = Date()
        showDailyChallenge = false
        
        if isCorrect {
            handleCorrectAnswer(country, challengeType)
        } else {
            handleIncorrectAnswer()
        }
        
        saveProgress()
    }
    
    private func handleCorrectAnswer(_ country: Country, _ challengeType: DailyChallengeType) {
        userProgress.correctAnswers += 1
        userProgress.streak += 1
        userProgress.longestStreak = max(userProgress.longestStreak, userProgress.streak)
        
        // Mark this specific challenge as completed
        userProgress.markChallengeCompleted(countryName: country.name, challengeType: challengeType)
        
        // Mark the country as completed (legacy support)
        country.isCompleted = true
        userProgress.markCountryCompleted(country)
        
        // Check if all challenges for current level are completed for possible level progression
        let completionPercentage = userProgress.completionPercentage(for: userProgress.currentLevel)
        if completionPercentage >= AppConstants.Game.levelProgressionThreshold &&
            userProgress.currentLevel < AppConstants.Game.maxLevel {
            userProgress.currentLevel += 1
            Logger.log("Advanced to level \(userProgress.currentLevel): \(completionPercentage * 100)% completed", level: .info)
        }
        
        // Cancel today's notifications when challenge is completed
        NotificationManager.shared.cancelTodaysNotifications()
    }
    
    private func handleIncorrectAnswer() {
        userProgress.streak = 0
    }
    
    // MARK: - Timer Management
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateNextChallengeTime()
        }
    }
    
    private func updateNextChallengeTime() {
        let nextChallengeDate = DateManager.shared.startOfTomorrow()
        timeUntilNextChallenge = DateManager.shared.formatTimeUntilNext(
            from: Date(),
            to: nextChallengeDate
        )
    }
    
    // MARK: - Game State
    
    func completeOnboarding() {
        userProgress.hasCompletedOnboarding = true
        showOnboarding = false
        saveProgress()
        
        // After onboarding, check if there's a daily challenge available
        checkDailyChallengeAvailability()
    }
    
    func getCurrentLevelDetails() -> Level? {
        return Level.allLevels.first { $0.id == userProgress.currentLevel }
    }
    
    // MARK: - Notification helpers
    
    func setupNotifications() {
        NotificationManager.shared.requestNotificationPermission { [weak self] granted in
            if granted, let hour = self?.userProgress.preferredReminderHour {
                NotificationManager.shared.scheduleReminderNotifications(
                    forDays: AppConstants.Notifications.scheduleDays,
                    atHour: hour
                )
            }
        }
    }
    
    func updateNotificationHour(_ hour: Int) {
        userProgress.preferredReminderHour = hour
        saveProgress()
        NotificationManager.shared.updateReminderHour(hour)
    }
}
