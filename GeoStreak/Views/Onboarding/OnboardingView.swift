//
//  OnboardingView 3.swift
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
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    coordinator.previousPage()
                                }
                            }) {
                                Text("Back")
                                    .fontWeight(.medium)
                                    .frame(width: 100, height: 50)
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.primary)
                                    .cornerRadius(10)
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
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    coordinator.nextPage()
                                }
                            }
                        }) {
                            Text(coordinator.currentPage == .getStarted ? "Get Started" : "Next")
                                .fontWeight(.bold)
                                .frame(width: 150, height: 50)
                                .background(coordinator.currentPage.color)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
                .animation(.easeInOut(duration: 0.3), value: coordinator.currentPage)
            }
            .navigationBarBackButtonHidden(true)
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
}