//
//  DesignChallengeViewModel.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 23/4/26.
//

import Foundation
import Combine

@MainActor
class DesignChallengeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentChallenge: DesignChallenge?
    @Published var isGenerating: Bool = false
    @Published var errorMessage: String?
    @Published var selectedDifficulty: DesignChallenge.Difficulty?
    @Published var selectedCategory: DesignChallenge.Category?
    @Published var savedChallenges: [DesignChallenge] = []
    
    // Model availability status
    @Published var isAIAvailable: Bool = false
    @Published var aiUnavailabilityReason: String?
    
    // MARK: - Private Properties
    
    private let service = DesignChallengeService()
    private let savedChallengesKey = "savedDesignChallenges"
    
    // MARK: - Initialization
    
    init() {
        checkAIAvailability()
        loadSavedChallenges()
        
        // Generate an initial challenge
        Task {
            await generateNewChallenge()
        }
    }
    
    // MARK: - Public Methods
    
    /// Check if AI is available
    func checkAIAvailability() {
        isAIAvailable = service.isModelAvailable()
        aiUnavailabilityReason = service.unavailabilityReason()
        
        if isAIAvailable {
            print("✅ [DesignChallengeVM] Apple Intelligence is available")
        } else if let reason = aiUnavailabilityReason {
            print("⚠️ [DesignChallengeVM] Apple Intelligence unavailable: \(reason)")
        }
    }
    
    /// Generate a new design challenge
    func generateNewChallenge() async {
        isGenerating = true
        errorMessage = nil
        
        print("🎨 [DesignChallengeVM] Generating new challenge...")
        print("🎨 [DesignChallengeVM] Filters - Difficulty: \(selectedDifficulty?.rawValue ?? "Any"), Category: \(selectedCategory?.rawValue ?? "Any")")
        
        do {
            let challenge = try await service.generateChallenge(
                difficulty: selectedDifficulty,
                category: selectedCategory
            )
            
            currentChallenge = challenge
            print("✅ [DesignChallengeVM] Challenge generated successfully")
            
        } catch {
            errorMessage = "Failed to generate challenge: \(error.localizedDescription)"
            print("❌ [DesignChallengeVM] Error: \(errorMessage ?? "Unknown error")")
            
            // Fallback to a curated challenge
            currentChallenge = DesignChallenge.randomCurated
        }
        
        isGenerating = false
    }
    
    /// Save the current challenge
    func saveCurrentChallenge() {
        guard let challenge = currentChallenge else { return }
        
        // Check if already saved
        if savedChallenges.contains(where: { $0.id == challenge.id }) {
            print("⚠️ [DesignChallengeVM] Challenge already saved")
            return
        }
        
        savedChallenges.insert(challenge, at: 0)
        persistSavedChallenges()
        print("💾 [DesignChallengeVM] Challenge saved: \(challenge.title)")
    }
    
    /// Remove a saved challenge
    func removeSavedChallenge(_ challenge: DesignChallenge) {
        savedChallenges.removeAll { $0.id == challenge.id }
        persistSavedChallenges()
        print("🗑️ [DesignChallengeVM] Challenge removed: \(challenge.title)")
    }
    
    /// Check if current challenge is saved
    func isCurrentChallengeSaved() -> Bool {
        guard let challenge = currentChallenge else { return false }
        return savedChallenges.contains(where: { $0.id == challenge.id })
    }
    
    /// Clear all filters
    func clearFilters() {
        selectedDifficulty = nil
        selectedCategory = nil
    }
    
    // MARK: - Private Methods
    
    /// Load saved challenges from UserDefaults
    private func loadSavedChallenges() {
        guard let data = UserDefaults.standard.data(forKey: savedChallengesKey),
              let decoded = try? JSONDecoder().decode([DesignChallenge].self, from: data) else {
            print("📂 [DesignChallengeVM] No saved challenges found")
            return
        }
        
        savedChallenges = decoded
        print("📂 [DesignChallengeVM] Loaded \(savedChallenges.count) saved challenges")
    }
    
    /// Persist saved challenges to UserDefaults
    private func persistSavedChallenges() {
        guard let encoded = try? JSONEncoder().encode(savedChallenges) else {
            print("❌ [DesignChallengeVM] Failed to encode saved challenges")
            return
        }
        
        UserDefaults.standard.set(encoded, forKey: savedChallengesKey)
        print("💾 [DesignChallengeVM] Persisted \(savedChallenges.count) challenges")
    }
}
