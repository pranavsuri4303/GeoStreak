//
//  DailyQuizView.swift
//  GeoStreak
//
//  Created by Pranav Suri on 2025-03-11.
//

import SwiftUI

struct DailyQuizView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var userGuess: String = ""
    @State private var showFeedback = false
    @State private var isCorrect = false
    @State private var showQuirkyPrompt = false
    @State private var showHint = false
    
    private let quirkyMessages = [
        "Maybe ask a fellow human instead of Google? Remember those? 😉",
        "Try asking someone nearby! They may surprise you with their knowledge.",
        "Instead of searching, why not strike up a geography conversation?",
        "Time to make your geography teacher proud! Or call them for help...",
        "Know anyone who's traveled a lot? Now's the time to text them!"
    ]
    
    private var randomQuirkyMessage: String {
        quirkyMessages.randomElement() ?? quirkyMessages[0]
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("GeoStreak")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Level & Streak Counter
            if let levelDetails = gameManager.getCurrentLevelDetails() {
                HStack(spacing: 10) {
                    Text("Level \(levelDetails.id): \(levelDetails.name)")
                        .font(.headline)
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            if let todaysCountry = gameManager.todaysCountry {
                // Question
                VStack(spacing: 15) {
                    Text("What is the capital of")
                        .font(.title2)
                    
                    Text(todaysCountry.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(todaysCountry.flag)
                        .font(.system(size: 80))
                        .padding()
                    
                    if showHint {
                        Text("Level: \(todaysCountry.level) - \(Level.allLevels.first { $0.id == todaysCountry.level }?.description ?? "")")
                            .font(.subheadline)
                            .italic()
                            .padding(.top, 5)
                    }
                }
                .padding()
                
                // Input field
                if !gameManager.hasTodaysAnswer {
                    TextField("Enter capital city", text: $userGuess)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 40)
                        .disabled(gameManager.hasTodaysAnswer)
                    
                    Button(action: submitGuess) {
                        Text("Submit")
                            .fontWeight(.semibold)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(userGuess.isEmpty || gameManager.hasTodaysAnswer)
                    
                    Button(action: { showHint = true }) {
                        Text("Show Hint")
                            .foregroundColor(.blue)
                    }
                    .opacity(showHint ? 0 : 1)
                } else {
                    // Already answered today
                    VStack {
                        if isCorrect {
                            Text("Correct! The capital is \(todaysCountry.capital)")
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                                .padding()
                            
                            Text("Come back tomorrow for a new country!")
                                .padding(.top, 5)
                        } else {
                            Text("Nice try! The capital is \(todaysCountry.capital)")
                                .fontWeight(.semibold)
                                .foregroundColor(.red)
                                .padding()
                            
                            Text(randomQuirkyMessage)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        
                        Text("Fun fact: \(todaysCountry.funFact)")
                            .font(.body)
                            .italic()
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .padding()
                }
            } else {
                Text("Loading today's challenge...")
            }
            
            Spacer()
            
            // Countdown to next challenge
            if gameManager.hasTodaysAnswer {
                Text("Next country in \(gameManager.timeUntilNextChallenge)")
                    .font(.subheadline)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            gameManager.checkDailyReset()
        }
        .alert(isPresented: $showQuirkyPrompt) {
            Alert(
                title: Text("Not quite right!"),
                message: Text(randomQuirkyMessage),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
    
    private func submitGuess() {
        isCorrect = gameManager.submitAnswer(guess: userGuess)
        
        if !isCorrect {
            showQuirkyPrompt = true
        }
        
        userGuess = ""
    }
}
