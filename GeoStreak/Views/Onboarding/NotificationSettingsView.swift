//
//  NotificationSettingsView.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import SwiftUI

struct NotificationSettingsView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    var body: some View {
        VStack(spacing: AppConstants.Layout.large) {
            Spacer()
            
            Image(systemName: OnboardingPageType.notifications.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: AppConstants.Layout.xxLarge, height: AppConstants.Layout.xxLarge)
                .foregroundColor(OnboardingPageType.notifications.color)
                .padding()
                .background(
                    Circle()
                        .fill(OnboardingPageType.notifications.color.opacity(0.1))
                        .frame(width: 180, height: 180)
                )
                .transition(.scale.combined(with: .opacity))
            
            Text(OnboardingPageType.notifications.title)
                .font(AppConstants.Typography.title1())
                .multilineTextAlignment(.center)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            
            Text(OnboardingPageType.notifications.description)
                .font(AppConstants.Typography.body())
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppConstants.Layout.xLarge)
                .foregroundColor(AppConstants.Colors.secondaryText)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            
            VStack(spacing: AppConstants.Layout.small) {
                ForEach(ReminderOption.options) { option in
                    ReminderOptionButton(
                        option: option,
                        isSelected: coordinator.selectedReminderHour == option.hour,
                        action: {
                            withAnimation(AppConstants.Layout.defaultAnimation) {
                                coordinator.selectedReminderHour = option.hour
                            }
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.top, AppConstants.Layout.large)
            
            // Show notification status message if determined
            if coordinator.notificationStatus != .notDetermined {
                HStack {
                    Image(systemName: coordinator.notificationStatus == .granted ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(coordinator.notificationStatus == .granted ? AppConstants.Colors.success : AppConstants.Colors.error)
                    
                    Text(coordinator.notificationStatus == .granted
                         ? "Notifications enabled! You'll receive daily reminders."
                         : "Notifications disabled. Enable in Settings to receive reminders.")
                        .font(AppConstants.Typography.footnote())
                        .foregroundColor(coordinator.notificationStatus == .granted ? AppConstants.Colors.success : AppConstants.Colors.error)
                }
                .padding(AppConstants.Layout.medium)
                .background(Color(coordinator.notificationStatus == .granted ? .systemGreen : .systemRed).opacity(0.1))
                .cornerRadius(AppConstants.Layout.smallRadius)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            Spacer()
        }
        .padding(.horizontal, AppConstants.Layout.screenPadding)
        .background(AppConstants.Colors.background)
        .alert(AppConstants.Notifications.notificationPermissionTitle, isPresented: $coordinator.showPermissionAlert) {
            Button(AppConstants.Text.continueButton, role: .none) {
                coordinator.requestNotificationPermissions()
            }
            Button(AppConstants.Text.skipButton, role: .cancel) {
                coordinator.notificationStatus = .denied
                withAnimation(AppConstants.Layout.defaultAnimation) {
                    coordinator.advanceToNextPage()
                }
            }
        } message: {
            Text(AppConstants.Notifications.notificationPermissionMessage)
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
                VStack(alignment: .leading, spacing: AppConstants.Layout.xxxSmall) {
                    Text(option.name)
                        .font(AppConstants.Typography.headline())
                        .foregroundColor(isSelected ? AppConstants.Colors.primary : AppConstants.Colors.primaryText)
                    
                    Text(option.description)
                        .font(AppConstants.Typography.caption1())
                        .foregroundColor(AppConstants.Colors.secondaryText)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppConstants.Colors.primary)
                        .font(.system(size: AppConstants.Typography.title3))
                        .transition(.scale)
                }
            }
            .padding(.vertical, AppConstants.Layout.small)
            .padding(.horizontal, AppConstants.Layout.medium)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.Layout.smallRadius)
                    .fill(isSelected ? AppConstants.Colors.primary.opacity(0.1) : Color.gray.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppConstants.Layout.smallRadius)
                            .strokeBorder(isSelected ? AppConstants.Colors.primary : Color.gray.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(AppConstants.Layout.defaultAnimation, value: isSelected)
    }
}