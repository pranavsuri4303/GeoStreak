//
//  OnboardingView.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject var coordinator: OnboardingCoordinator
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        NavigationStack {
            ZStack {
                // Page content
                VStack {
                    switch coordinator.currentPage {
                    case .notifications:
                        NotificationSettingsView(coordinator: coordinator)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))
                    default:
                        OnboardingPageView(pageType: coordinator.currentPage)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))
                    }
                    
                    Spacer()
                    
                    // Navigation buttons
                    HStack {
                        if coordinator.currentPage != .welcome {
                            Button(action: {
                                withAnimation(AppConstants.Layout.defaultAnimation) {
                                    coordinator.previousPage()
                                }
                            }) {
                                Text(AppConstants.Text.backButton)
                                    .fontWeight(.medium)
                                    .frame(width: 100, height: AppConstants.Layout.buttonHeight)
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(AppConstants.Colors.primaryText)
                                    .cornerRadius(AppConstants.UI.cornerRadius)
                            }
                        } else {
                            Spacer()
                                .frame(width: 100)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if coordinator.currentPage == .getStarted {
                                coordinator.completeOnboarding()
                            } else {
                                withAnimation(AppConstants.Layout.defaultAnimation) {
                                    coordinator.nextPage()
                                }
                            }
                        }) {
                            Text(coordinator.currentPage == .getStarted ? AppConstants.Text.doneButton : AppConstants.Text.nextButton)
                                .fontWeight(.bold)
                                .frame(width: 150, height: AppConstants.Layout.buttonHeight)
                                .background(coordinator.currentPage.color)
                                .foregroundColor(.white)
                                .cornerRadius(AppConstants.UI.cornerRadius)
                        }
                    }
                    .padding(.horizontal, AppConstants.Layout.screenPadding * 1.5)
                    .padding(.bottom, AppConstants.Layout.xxLarge)
                }
                .animation(AppConstants.Layout.defaultAnimation, value: coordinator.currentPage)
            }
            .navigationBarBackButtonHidden(true)
        }
        .background(AppConstants.Colors.background)
        .edgesIgnoringSafeArea(.all)
    }
}