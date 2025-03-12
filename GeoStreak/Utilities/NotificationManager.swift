//
//  NotificationManager.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-19.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    // MARK: - Notification Functions
    
    /// Request notification permissions from the user
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
            
            if let error = error {
                Logger.log("Notification permission error: \(error.localizedDescription)", level: .error)
            }
        }
    }
    
    /// Schedule daily reminder notifications
    func scheduleReminderNotifications(forDays days: Int, atHour hour: Int) {
        let center = UNUserNotificationCenter.current()
        
        // First, check permission status
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                Logger.log("Notifications not authorized", level: .warning)
                return
            }
            
            self.scheduleNotifications(center: center, forDays: days, atHour: hour)
        }
    }
    
    private func scheduleNotifications(center: UNUserNotificationCenter, forDays days: Int, atHour hour: Int) {
        let content = UNMutableNotificationContent()
        content.title = AppConstants.Notifications.reminderTitle
        content.body = AppConstants.Notifications.reminderBody
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
                    Logger.log("Error scheduling notification: \(error.localizedDescription)", level: .error)
                }
            }
        }
    }
    
    /// Cancel today's notifications
    func cancelTodaysNotifications() {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let identifier = "reminder-\(todayComponents.year!)-\(todayComponents.month!)-\(todayComponents.day!)"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    /// Update notification hour preference
    func updateReminderHour(_ hour: Int) {
        // Cancel existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Reschedule with new hour
        scheduleReminderNotifications(forDays: AppConstants.Notifications.scheduleDays, atHour: hour)
    }
}