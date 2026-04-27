//
//  DesignChallengeService.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 23/4/26.
//

import Foundation
import FoundationModels

/// Service for generating design challenges using Apple's Foundation Models
@MainActor
@Observable
class DesignChallengeService {
    
    // MARK: - Properties
    
    private let model = SystemLanguageModel.default
    
    // MARK: - Public Methods
    
    /// Check if the AI model is available on this device
    func isModelAvailable() -> Bool {
        switch model.availability {
        case .available:
            return true
        default:
            return false
        }
    }
    
    /// Get the reason why the model is unavailable (if applicable)
    func unavailabilityReason() -> String? {
        switch model.availability {
        case .available:
            return nil
        case .unavailable(.deviceNotEligible):
            return "Device not eligible for Apple Intelligence"
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Apple Intelligence is not enabled in Settings"
        case .unavailable(.modelNotReady):
            return "Model is downloading or not ready yet"
        case .unavailable(let other):
            return "Model unavailable: \(other)"
        }
    }
    
    /// Generate a design challenge using AI
    func generateChallenge(
        difficulty: DesignChallenge.Difficulty? = nil,
        category: DesignChallenge.Category? = nil
    ) async throws -> DesignChallenge {
        
        // Check model availability first
        guard isModelAvailable() else {
            print("⚠️ [DesignChallengeService] Model not available, using curated challenge")
            return filteredCuratedChallenge(difficulty: difficulty, category: category)
        }
        
        // Try to generate with AI, but always fall back gracefully
        do {
            // Simplified prompt - just ask for a title
            let instructions = """
            You are a creative design challenge generator for makers and DIY enthusiasts.
            Generate a short, specific design challenge as a single sentence.
            Focus on physical products that can be made in a makerspace.
            Be creative and specific.
            """
            
            let session = LanguageModelSession(instructions: instructions)
            
            var prompt = "Generate a one-sentence design challenge"
            if let difficulty = difficulty {
                prompt += " at \(difficulty.rawValue.lowercased()) level"
            }
            if let category = category {
                prompt += " in the category of \(category.rawValue)"
            }
            prompt += "."
            
            print("🤖 [DesignChallengeService] Generating with prompt: \(prompt)")
            
            let response = try await session.respond(to: prompt, generating: SimpleChallengeResponse.self)
            
            print("✅ [DesignChallengeService] Generated: \(response.content.title)")
            
            return DesignChallenge(
                title: response.content.title,
                description: "",
                constraint: "",
                difficulty: difficulty ?? .intermediate,
                category: category ?? .general,
                isAIGenerated: true
            )
            
        } catch {
            // Silently fall back to curated challenges - this is expected behavior
            print("⚠️ [DesignChallengeService] Using curated challenge (AI unavailable)")
            return filteredCuratedChallenge(difficulty: difficulty, category: category)
        }
    }
    
    // MARK: - Private Methods
    
    /// Parse category from generated text (best effort)
    private func parseCategory(from text: String) -> DesignChallenge.Category {
        let lowercased = text.lowercased()
        
        if lowercased.contains("wood") || lowercased.contains("carpenter") {
            return .woodworking
        } else if lowercased.contains("electronic") || lowercased.contains("arduino") || lowercased.contains("circuit") {
            return .electronics
        } else if lowercased.contains("3d print") || lowercased.contains("laser cut") || lowercased.contains("cnc") {
            return .fabrication
        } else if lowercased.contains("sustain") || lowercased.contains("recycle") || lowercased.contains("eco") {
            return .sustainable
        } else if lowercased.contains("accessible") || lowercased.contains("disability") || lowercased.contains("adaptive") {
            return .accessible
        } else if lowercased.contains("furniture") || lowercased.contains("chair") || lowercased.contains("table") {
            return .furniture
        } else if lowercased.contains("tool") || lowercased.contains("organiz") || lowercased.contains("storage") {
            return .tools
        } else if lowercased.contains("wearable") || lowercased.contains("clothing") || lowercased.contains("wear") {
            return .wearable
        } else {
            return .general
        }
    }
    
    /// Get a curated challenge filtered by difficulty and/or category
    private func filteredCuratedChallenge(
        difficulty: DesignChallenge.Difficulty?,
        category: DesignChallenge.Category?
    ) -> DesignChallenge {
        var filtered = DesignChallenge.curatedChallenges
        
        if let difficulty = difficulty {
            filtered = filtered.filter { $0.difficulty == difficulty }
        }
        
        if let category = category {
            filtered = filtered.filter { $0.category == category }
        }
        
        return filtered.randomElement() ?? DesignChallenge.randomCurated
    }
}

// MARK: - Generable Response Type

@Generable(description: "A one-sentence design challenge")
struct SimpleChallengeResponse {
    @Guide(description: "A specific, creative design challenge as a single sentence")
    var title: String
}
