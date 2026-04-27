//
//  DesignChallengePrompts.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 24/4/26.
//

import Foundation

struct DesignChallengePrompts {
    static let all: [String] = [
      "Design a device that helps people remember to take medication without feeling nagged.",
      "Create a portable system to improve safety for people walking alone at night.",
      "Build a quiet alert system for classrooms to support non-verbal communication.",
      "Design a low-cost air quality monitor paired with a public awareness campaign.",
      "Create a smart donation box that tells stories of where contributions go.",
      "Design a wearable that detects stress and responds with calming feedback.",
      "Build a community fridge monitor that helps reduce food waste.",
      "Design a device that helps elderly people remember daily tasks.",
      "Create a system that rewards sustainable behavior like recycling or biking.",
      "Design an interactive exhibit about homelessness that builds empathy.",
      "Build a neighborhood flood warning system.",
      "Design a bias detector experience that reveals hidden bias in decisions.",
      "Create a device to assist people with hearing impairments in public spaces.",
      "Design a tool that helps students manage screen time more intentionally.",
      "Build a system that encourages genuine kindness in schools.",
      "Design a sculpture that changes color based on audience emotion.",
      "Create a light installation that reacts to sound like a living organism.",
      "Build a digital graffiti wall that evolves over time.",
      "Design a kinetic sculpture powered by wind or human movement.",
      "Create an artwork that only appears under specific lighting conditions.",
      "Design a piece that visualizes your heartbeat in real time.",
      "Build a storytelling box that reveals different narratives based on interaction.",
      "Create an interactive mirror that shows an alternate version of yourself.",
      "Design an installation about time passing using light and motion.",
      "Build a machine that turns drawings into music.",
      "Create an artwork that slowly destroys itself over time.",
      "Design a piece that reacts uniquely to each viewer.",
      "Build a memory machine that stores and replays moments.",
      "Create a sculpture expressing a social issue through movement.",
      "Design a wearable art piece that communicates mood.",
      "Build a smart plant that dramatically asks for water.",
      "Design a desk that tracks and improves posture.",
      "Create a device that translates motion into sound.",
      "Build a smart alarm clock that adapts to user behavior.",
      "Design a system that gamifies doing homework.",
      "Create a smart locker that improves security and usability.",
      "Build a playful device that pretends to detect lies.",
      "Design a focus environment controller for studying.",
      "Create a smart trash can that sorts waste automatically.",
      "Build a device that visualizes WiFi signals in a room.",
      "Design a wearable that communicates without a phone.",
      "Create a system that reacts to real-time weather changes.",
      "Build a device that tracks how often you smile.",
      "Design a gadget that encourages better sleep habits.",
      "Create a smart room that adapts to mood.",
      "Design a machine that dramatically judges your life choices.",
      "Create a device that claps when you complete basic tasks.",
      "Build a procrastination assistant that blocks distractions.",
      "Design a useless machine that offers emotional support.",
      "Create a toaster concept that prints motivational quotes.",
      "Build a device that humorously translates pet thoughts.",
      "Design a chair that requires answering a question before sitting.",
      "Create a hat that reacts to awkward silence.",
      "Build a mirror that roasts instead of compliments.",
      "Design a device that over-celebrates tiny achievements.",
      "Create a drama button that adds suspenseful music to life.",
      "Build a system that detects cringe moments.",
      "Design a complaining backpack that reacts to weight.",
      "Create a lamp that gets tired and dims emotionally.",
      "Build a device that aggressively tells you to go outside.",
      "Design a product that questions the meaning of productivity.",
      "Create a system that visualizes your daily decisions.",
      "Build something that challenges the idea of privacy.",
      "Design an object that changes meaning over time.",
      "Create an installation about digital addiction.",
      "Build a device that shows how often you are influenced by others.",
      "Design a system that makes invisible labor visible.",
      "Create an artifact imagined from the future.",
      "Build a device that visualizes inequality.",
      "Design something that only works through collaboration.",
      "Create a project exploring attention as a limited resource.",
      "Build a system that highlights misinformation.",
      "Design a product that becomes less useful over time.",
      "Create an experience about memory distortion.",
      "Build something that represents identity in layers.",
      "Design a modular desk accessory system.",
      "Create a foldable portable workspace.",
      "Build a customizable phone stand ecosystem.",
      "Design a better cable management solution.",
      "Create a buildable kit that teaches a concept.",
      "Build a compact storage system for small spaces.",
      "Design a product that is easy to repair.",
      "Create a tool that organizes creative ideas physically.",
      "Build a product using only recycled materials.",
      "Design a multi-use everyday carry object.",
      "Create an app that encourages offline interaction.",
      "Design a platform for anonymous kindness.",
      "Build a system that connects strangers through shared interests.",
      "Design a digital experience that reduces anxiety.",
      "Create a storytelling app triggered by physical interactions.",
      "Design an escape room based on a social issue.",
      "Create an interactive museum exhibit for teenagers.",
      "Build a hybrid game that exists physically and digitally.",
      "Design a product and app ecosystem for a daily ritual.",
      "Create a wearable that unlocks digital experiences.",
      "Design something that makes people laugh in public spaces.",
      "Create a project that fails beautifully.",
      "Build something that evolves through interaction.",
      "Design a system where the user becomes part of the product.",
      "Create something you do not fully understand but want to explore."
    ]
}

/// Manages the selection of design challenge prompts without repetition
@Observable
class DesignChallengeManager {
    private(set) var usedPrompts: Set<String> = []
    private var availablePrompts: [String]
    
    init() {
        self.availablePrompts = DesignChallengePrompts.all
    }
    
    /// Returns a randomly selected prompt that hasn't been used yet
    /// - Returns: A unique prompt, or nil if all prompts have been used
    func nextPrompt() -> String? {
        guard !availablePrompts.isEmpty else {
            return nil
        }
        
        let prompt = availablePrompts.randomElement()!
        availablePrompts.removeAll { $0 == prompt }
        usedPrompts.insert(prompt)
        
        return prompt
    }
    
    /// Resets the manager, making all prompts available again
    func reset() {
        availablePrompts = DesignChallengePrompts.all
        usedPrompts.removeAll()
    }
    
    /// Number of remaining prompts
    var remainingCount: Int {
        availablePrompts.count
    }
    
    /// Whether all prompts have been used
    var hasMorePrompts: Bool {
        !availablePrompts.isEmpty
    }
}
