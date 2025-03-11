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
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: pageType.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
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
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            
            Text(pageType.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .foregroundColor(.secondary)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .transition(.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        ))
    }
}