//
//  OnboardingPageView.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import SwiftUI

struct OnboardingPageView: View {
    let pageType: OnboardingPageType
    
    var body: some View {
        VStack(spacing: AppConstants.Layout.large) {
            Spacer()
            
            Image(systemName: pageType.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: AppConstants.Layout.xxLarge * 1.2, height: AppConstants.Layout.xxLarge * 1.2)
                .foregroundColor(pageType.color)
                .padding()
                .background(
                    Circle()
                        .fill(pageType.color.opacity(0.1))
                        .frame(width: 180, height: 180)
                )
                .accessibility(label: Text("Illustration for \(pageType.title)"))
                .transition(.scale.combined(with: .opacity))
            
            Text(pageType.title)
                .font(AppConstants.Typography.title1())
                .multilineTextAlignment(.center)
                .padding(.top, AppConstants.Layout.large)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            
            Text(pageType.description)
                .font(AppConstants.Typography.body())
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppConstants.Layout.xLarge)
                .foregroundColor(AppConstants.Colors.secondaryText)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            
            Spacer()
        }
        .padding(AppConstants.Layout.screenPadding)
        .background(AppConstants.Colors.background)
        .transition(.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        ))
    }
}