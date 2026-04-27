//
//  DesignChallengeView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 23/4/26.
//

import SwiftUI

struct DesignChallengeView: View {
    @State private var challengeManager = DesignChallengeManager()
    @State private var currentChallenge = "Tap the button to get started"
    @State private var isAnimating = false
    @State private var particlesTrigger = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.makerYellow.opacity(0.1),
                    Color.makerYellow.opacity(0.05),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Challenge card
                VStack(spacing: 24) {
                    // Icon or emoji
                    ZStack {
                        Circle()
                            .fill(Color.makerYellow.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                        
                        Image(systemName: currentChallenge == "Tap the button to get started" ? "sparkles" : "lightbulb.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.makerYellow)
                            .symbolEffect(.bounce, value: particlesTrigger)
                    }
                    .onAppear { isAnimating = true }
                    
                    // Challenge text
                    Text(currentChallenge)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.primary, .primary.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .padding(.horizontal, 32)
                        .id(currentChallenge) // Forces re-render for animation
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity).combined(with: .move(edge: .top)),
                            removal: .scale.combined(with: .opacity).combined(with: .move(edge: .bottom))
                        ))
                }
                .padding(.vertical, 48)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.background)
                        .shadow(color: Color.makerYellow.opacity(0.2), radius: 20, x: 0, y: 10)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal, 24)
                        
                
                // Generate Button
                Button(action: generateChallenge) {
                    HStack(spacing: 12) {
                        Image(systemName: challengeManager.hasMorePrompts ? "wand.and.stars" : "arrow.clockwise")
                            .font(.title3)
                        
                        Text(challengeManager.hasMorePrompts ? "Generate Challenge" : "Start Over")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.makerYellow)
                            
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [.white.opacity(0.3), .clear],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                    )
                    .foregroundStyle(.white)
                    .shadow(color: Color.makerYellow.opacity(0.4), radius: 12, x: 0, y: 6)
                }
                .padding(.horizontal, 32)
                .buttonStyle(.plain)
                .sensoryFeedback(.success, trigger: particlesTrigger)
                
                Spacer()
            }
        }
    }
    
    private func generateChallenge() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            if let newChallenge = challengeManager.nextPrompt() {
                currentChallenge = newChallenge
                particlesTrigger.toggle()
            } else {
                // All prompts used - reset
                challengeManager.reset()
                currentChallenge = challengeManager.nextPrompt() ?? "No prompts available"
                particlesTrigger.toggle()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    DesignChallengeView()
}

