//
//  ErrorView.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//


import SwiftUI

struct ErrorView: View {
    var errorMessage: String
    var retryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.red)
            
            Text("Oops! Something went wrong")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(errorMessage)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            if let retry = retryAction {
                Button(action: retry) {
                    Text("Try Again")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
            }
        }
        .padding()
        .background(Color.background)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

#Preview {
    ErrorView(
        errorMessage: "Could not load game data. Please check your connection and try again.",
        retryAction: { print("Retry tapped") }
    )
}
