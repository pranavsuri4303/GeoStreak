//
//  DailyChallengeView.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-12.
//

import SwiftUI

struct DailyChallengeView: View {
    @ObservedObject var gameManager: GameManager
    @State private var answer: String = ""
    @State private var showConfetti: Bool = false
    @State private var showIncorrectFeedback: Bool = false
    @State private var isAnswerSubmitted: Bool = false
    
    var body: some View {
        ChallengePage {
            HStack {
                Spacer()
                StreakBadge(value: gameManager.userProgress.streak)
            }
            
            Spacer()
            
            if let challengeType = gameManager.todaysChallengeType, let country = gameManager.todaysCountry {
                Text(challengeType.prompt)
                    .font(AppConstants.Typography.title1())
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                VStack(spacing: 16) {
                    // Show country name if the challenge type requires it
                    if challengeType == .countryToCapital {
                        Text(country.name)
                            .font(AppConstants.Typography.title2())
                            .foregroundColor(AppConstants.Colors.primary)
                            .padding(.bottom, 8)
                    }
                    
                    // Always show the flag
                    FlagView(flag: country.flag)
                }
                .padding(.bottom, 32)
                
                TextField(challengeType.inputPlaceholder, text: $answer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)
                    .disabled(isAnswerSubmitted)
                
                Spacer()
                
                if isAnswerSubmitted {
                    // Show result message
                    Text(showConfetti ? "Correct! Great job!" : "Not quite. The correct answer was: \(gameManager.todaysChallengeType?.getExpectedAnswer(from: country) ?? "")")
                        .font(AppConstants.Typography.body())
                        .foregroundColor(showConfetti ? AppConstants.Colors.success : AppConstants.Colors.error)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadius)
                                .fill(Color.white.opacity(0.1))
                        )
                        .padding()
                } else {
                    // Submit button when not yet submitted
                    Button {
                        submitAnswer()
                    } label: {
                        Text(AppConstants.Text.submitAnswer)
                            .fontWeight(.bold)
                            .frame(width: 150, height: AppConstants.Layout.buttonHeight)
                            .background(AppConstants.Colors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(AppConstants.UI.cornerRadius)
                    }
                }
            } else {
                Text("Loading your daily challenge...")
                    .font(AppConstants.Typography.title2())
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .confettiCannon(isShowing: $showConfetti, particleCount: 200, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
        .onAppear {
            // Fetch the challenge when the view appears
            gameManager.fetchTodaysChallenge()
        }
    }
    
    private func submitAnswer() {
        guard !answer.isEmpty, let challengeType = gameManager.todaysChallengeType, let country = gameManager.todaysCountry else { return }
        
        // First, verify the answer without side effects
        let isCorrect = gameManager.verifyAnswer(country: country, challengeType: challengeType, guess: answer)
        
        // Update UI immediately
        showConfetti = isCorrect
        showIncorrectFeedback = !isCorrect
        isAnswerSubmitted = true
        
        // Generate haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(isCorrect ? .success : .error)
        
        if isCorrect {
            // Submit the answer to the game manager after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                // Save the result to database
                self.gameManager.submitAnswer(guess: self.answer, isCorrect: isCorrect)
                // Then dismiss the view
                self.gameManager.showDailyChallenge = false
            }
        } else {
            // For incorrect answers, submit immediately then dismiss
            self.gameManager.submitAnswer(guess: self.answer, isCorrect: isCorrect)
            // Allow a moment to see the incorrect feedback
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.gameManager.showDailyChallenge = false
            }
        }
    }
}
