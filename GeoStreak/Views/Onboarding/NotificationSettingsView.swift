//
//  NotificationSettingsView 2.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import SwiftUI

struct NotificationSettingsView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: OnboardingPageType.notifications.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(OnboardingPageType.notifications.color)
                .padding()
                .background(
                    Circle()
                        .fill(OnboardingPageType.notifications.color.opacity(0.1))
                        .frame(width: 180, height: 180)
                )
                .transition(.scale.combined(with: .opacity))
            
            Text(OnboardingPageType.notifications.title)
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            
            Text(OnboardingPageType.notifications.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .foregroundColor(.secondary)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            
            VStack(spacing: 12) {
                ForEach(ReminderOption.options) { option in
                    ReminderOptionButton(
                        option: option,
                        isSelected: coordinator.selectedReminderHour == option.hour,
                        action: {
                            withAnimation(.spring()) {
                                coordinator.selectedReminderHour = option.hour
                            }
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.top, 20)
            
            // Show notification status message if determined
            if coordinator.notificationStatus != .notDetermined {
                HStack {
                    Image(systemName: coordinator.notificationStatus == .granted ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(coordinator.notificationStatus == .granted ? .green : .red)
                    
                    Text(coordinator.notificationStatus == .granted
                         ? "Notifications enabled! You'll receive daily reminders."
                         : "Notifications disabled. Enable in Settings to receive reminders.")
                        .font(.footnote)
                        .foregroundColor(coordinator.notificationStatus == .granted ? .green : .red)
                }
                .padding()
                .background(Color(coordinator.notificationStatus == .granted ? .systemGreen : .systemRed).opacity(0.1))
                .cornerRadius(8)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
        .alert("Allow Notifications", isPresented: $coordinator.showPermissionAlert) {
            Button("Allow", role: .none) {
                coordinator.requestNotificationPermissions()
            }
            Button("Skip", role: .cancel) {
                coordinator.notificationStatus = .denied
                withAnimation(.easeInOut(duration: 0.3)) {
                    coordinator.advanceToNextPage()
                }
            }
        } message: {
            Text("Enable notifications to get daily reminders for your geography challenge.")
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        ))
    }
}

struct ReminderOptionButton: View {
    let option: ReminderOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.name)
                        .font(.headline)
                        .foregroundColor(isSelected ? .blue : .primary)
                    
                    Text(option.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                        .transition(.scale)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(isSelected ? Color.blue : Color.gray.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(), value: isSelected)
    }
}