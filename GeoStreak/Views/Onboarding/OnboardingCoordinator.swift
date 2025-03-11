//
//  OnboardingCoordinator.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import SwiftUI
import UserNotifications

class OnboardingCoordinator: ObservableObject {
    @Published var currentPage: OnboardingPageType = .welcome
    @Published var selectedReminderHour: Int = 8
    @Published var notificationStatus: NotificationPermissionStatus = .notDetermined
    @Published var showPermissionAlert: Bool = false
    
    var gameManager: GameManager
    
    init(gameManager: GameManager) {
        self.gameManager = gameManager
    }
    
    func nextPage() {
        if currentPage == .notifications {
            showPermissionAlert = true
            return
        }
        
        advanceToNextPage()
    }
    
    func advanceToNextPage() {
        let allPages = OnboardingPageType.allCases
        if let currentIndex = allPages.firstIndex(of: currentPage),
           currentIndex < allPages.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage = allPages[currentIndex + 1]
            }
        }
    }
    
    func previousPage() {
        let allPages = OnboardingPageType.allCases
        if let currentIndex = allPages.firstIndex(of: currentPage),
           currentIndex > 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage = allPages[currentIndex - 1]
            }
        }
    }
    
    func completeOnboarding() {
        gameManager.userProgress.preferredReminderHour = selectedReminderHour
        
        if notificationStatus == .granted {
            gameManager.setupNotifications()
        }
        
        gameManager.completeOnboarding()
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.notificationStatus = granted ? .granted : .denied
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.advanceToNextPage()
                }
            }
            
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
}