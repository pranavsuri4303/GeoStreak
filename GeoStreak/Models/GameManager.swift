//  GameManager.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import Foundation
import SwiftData
import Combine
import UserNotifications // Added for notifications

// MARK: - Game Logic
class GameManager: ObservableObject {
    @Published var userProgress: UserProgress
    @Published var todaysCountry: Country?
    @Published var hasTodaysAnswer = false
    @Published var timeUntilNextChallenge = ""
    @Published var showOnboarding = false
    @Published var isLoading = true
    
    private var modelContext: ModelContext
    private var countryRepository: CountryRepository
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    init(context: ModelContext) {
        self.modelContext = context
        self.countryRepository = CountryRepository(context: context)
        self.userProgress = UserProgress()
        loadUserProgress()
    }
    
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
            
            setupCountryForToday()
            startTimer()
            isLoading = false
        } catch {
            print("Error loading user progress: \(error)")
            setupCountryForToday()
            startTimer()
            isLoading = false
        }
    }
    
    private func saveProgress() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving progress: \(error)")
        }
    }
    
    func setupCountryForToday() {
        let availableCountries = countryRepository.getUncompletedCountriesForLevel(userProgress.currentLevel)
        
        if availableCountries.isEmpty {
            if userProgress.currentLevel < Level.allLevels.count {
                userProgress.currentLevel += 1
                setupCountryForToday()
            } else {
                countryRepository.resetAllCountriesCompletion()
                userProgress.currentLevel = 1
                setupCountryForToday()
            }
            return
        }
        
        todaysCountry = availableCountries.randomElement()
        checkDailyReset()
    }
    
    func submitAnswer(guess: String) -> Bool {
        guard let country = todaysCountry, !hasTodaysAnswer else { return false }
        
        userProgress.totalAnswers += 1
        hasTodaysAnswer = true
        userProgress.lastCompletedDate = Date()
        
        let isCorrect = guess.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ==
                       country.capital.lowercased()
        
        if isCorrect {
            userProgress.correctAnswers += 1
            userProgress.streak += 1
            userProgress.longestStreak = max(userProgress.longestStreak, userProgress.streak)
            country.isCompleted = true
            userProgress.markCountryCompleted(country)
            
            if countryRepository.areAllCountriesCompletedForLevel(userProgress.currentLevel) &&
               userProgress.currentLevel < Level.allLevels.count {
                userProgress.currentLevel += 1
            }
            
            // Cancel today's notifications when challenge is completed
            cancelTodaysNotifications()
        } else {
            userProgress.streak = 0
        }
        
        saveProgress()
        setupCountryForToday()
        return isCorrect
    }
    
    func completeOnboarding() {
        userProgress.hasCompletedOnboarding = true
        showOnboarding = false
        saveProgress()
    }
    
    func updateModelContext(_ context: ModelContext) {
        self.modelContext = context
        self.countryRepository = CountryRepository(context: context)
        loadUserProgress()
    }
    
    func checkDailyReset() {
        if let lastDate = userProgress.lastCompletedDate,
           !Calendar.current.isDateInToday(lastDate) {
            hasTodaysAnswer = false
            setupCountryForToday()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateNextChallengeTime()
        }
    }
    
    private func updateNextChallengeTime() {
        let calendar = Calendar.current
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) else { return }
        let midnight = calendar.startOfDay(for: tomorrow)
        guard let nextChallengeTime = calendar.date(byAdding: .minute, value: 1, to: midnight) else { return }
        
        let difference = calendar.dateComponents([.hour, .minute, .second], from: Date(), to: nextChallengeTime)
        
        timeUntilNextChallenge = String(format: "%02d:%02d:%02d",
                                      difference.hour ?? 0,
                                      difference.minute ?? 0,
                                      difference.second ?? 0)
    }
    
    func getCurrentLevelDetails() -> Level? {
        return Level.allLevels.first { $0.id == userProgress.currentLevel }
    }
    
    func addNewCountries(_ countries: [Country]) {
        countryRepository.addNewCountries(countries)
    }
    
    func loadAdditionalCountries() {
        addNewCountries(Country.sampleCountries)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Notification Functions
    
    func setupNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    self.scheduleNotifications(forDays: 365, atHour: self.userProgress.preferredReminderHour)
                }
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    func scheduleNotifications(forDays days: Int, atHour hour: Int) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Daily Challenge Reminder"
        content.body = "Don't forget to complete your daily geography challenge!"
        content.sound = .default
        
        let calendar = Calendar.current
        for day in 0..<days {
            guard let futureDate = calendar.date(byAdding: .day, value: day, to: Date()) else { continue }
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: futureDate)
            
            var timeComponents = dateComponents
            timeComponents.hour = hour
            timeComponents.minute = 0
            timeComponents.second = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents, repeats: false)
            let identifier = "reminder-\(dateComponents.year!)-\(dateComponents.month!)-\(dateComponents.day!)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    }
    
    private func cancelTodaysNotifications() {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let identifier = "reminder-\(todayComponents.year!)-\(todayComponents.month!)-\(todayComponents.day!)"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}