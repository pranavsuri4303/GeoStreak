//
//  StreakBadge.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import SwiftUI
import Foundation

public struct StreakBadge: View {
    private let value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    public var body: some View {
        HStack {
            Image(systemName: "flame.fill")
                .foregroundColor(AppConstants.Colors.accent)
                .font(.system(size: AppConstants.Layout.smallIconSize))
            
            Text("\(value)")
                .font(AppConstants.Typography.callout(.semibold))
                .foregroundColor(AppConstants.Colors.accent)
        }
        .padding(.horizontal, AppConstants.Layout.small)
        .padding(.vertical, AppConstants.Layout.xxSmall)
        .background(AppConstants.Colors.accent.opacity(0.18))
        .cornerRadius(AppConstants.Layout.smallRadius)
    }
}
