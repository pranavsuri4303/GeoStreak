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
    
    init(value: Int)
    {
        self.value = value
    }
    
    public var body: some View {
        HStack {
            Image(systemName: "flame.fill")
                .foregroundColor(.orange)
            Text("\(value)")
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.orange.opacity(0.18))
        .cornerRadius(10)
    }
}

