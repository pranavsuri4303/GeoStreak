//
//  LevelCard.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import SwiftUI
import Foundation

struct LevelCard: View {
    let level: Level
    let isUnlocked: Bool
    let isCurrent: Bool
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Level \(level.id)")
                    .font(.headline)
                    .foregroundColor(isUnlocked ? .primary : .gray)
                
                Spacer()
                
                if isCurrent {
                    Text("CURRENT")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                } else if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                }
            }
            
            Text(level.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(isUnlocked ? .primary : .gray)
                .padding(.bottom, 1)
            
            Text(level.description)
                .font(.body)
                .foregroundColor(isUnlocked ? .primary : .gray)
                .padding(.bottom, 4)
            
            ProgressView(value: progress)
                .tint(isUnlocked ? (isCurrent ? .blue : .green) : .gray)
            
            Text("\(Int(progress * 100))% Complete")
                .font(.caption)
                .foregroundColor(isUnlocked ? .secondary : .gray)
                .padding(.top, 4)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isCurrent ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}
