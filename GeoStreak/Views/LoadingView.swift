//
//  LoadingView.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//


import SwiftUI

struct LoadingView: View {
    var message: String = "Loading your geography adventure..."
    
    var body: some View {
        VStack(spacing: 20) {
            Text("GeoStreak")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Image(systemName: "globe")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
                .padding()
            
            ProgressView()
                .scaleEffect(1.5)
                .padding()
            
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .background(Color.background)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

#Preview {
    LoadingView()
}
