//
//  DesignChallenge.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 23/4/26.
//

import Foundation

struct DesignChallenge: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let description: String
    let constraint: String
    let difficulty: Difficulty
    let category: Category
    let createdAt: Date
    let isAIGenerated: Bool
    
    enum Difficulty: String, Codable, CaseIterable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
        
        var emoji: String {
            switch self {
            case .beginner: return "🌱"
            case .intermediate: return "⚡️"
            case .advanced: return "🔥"
            }
        }
    }
    
    enum Category: String, Codable, CaseIterable {
        case woodworking = "Woodworking"
        case electronics = "Electronics"
        case fabrication = "Fabrication"
        case sustainable = "Sustainable Design"
        case accessible = "Accessible Design"
        case furniture = "Furniture"
        case tools = "Tools & Organization"
        case wearable = "Wearable Tech"
        case general = "General"
        
        var icon: String {
            switch self {
            case .woodworking: return "hammer.fill"
            case .electronics: return "bolt.fill"
            case .fabrication: return "cube.fill"
            case .sustainable: return "leaf.fill"
            case .accessible: return "figure.arms.open"
            case .furniture: return "chair.fill"
            case .tools: return "wrench.and.screwdriver.fill"
            case .wearable: return "applewatch"
            case .general: return "lightbulb.fill"
            }
        }
    }
    
    init(id: String = UUID().uuidString,
         title: String,
         description: String,
         constraint: String,
         difficulty: Difficulty,
         category: Category,
         createdAt: Date = Date(),
         isAIGenerated: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.constraint = constraint
        self.difficulty = difficulty
        self.category = category
        self.createdAt = createdAt
        self.isAIGenerated = isAIGenerated
    }
    
    // MARK: - Sample Challenges (Curated Fallback)
    
    static let curatedChallenges: [DesignChallenge] = [
        DesignChallenge(
            title: "The Sustainable Storage Solution",
            description: "Design a modular storage system using only reclaimed wood and recycled metal hardware. Your design must accommodate at least 5 different workshop tools and be wall-mountable.",
            constraint: "Budget: Under $20 in materials • Size: Max 24\" wide",
            difficulty: .beginner,
            category: .sustainable
        ),
        DesignChallenge(
            title: "The Tiny Desk Organizer",
            description: "Create a desk organizer that maximizes vertical space while maintaining a footprint no larger than a coffee mug. It should hold pens, sticky notes, phone, and small accessories.",
            constraint: "Footprint: 4\" diameter • Materials: Your choice",
            difficulty: .beginner,
            category: .tools
        ),
        DesignChallenge(
            title: "Smart Plant Monitor",
            description: "Build an IoT-enabled plant monitoring system that tracks soil moisture, light levels, and temperature. Display the data on a simple LED indicator or mobile app.",
            constraint: "Budget: Under $30 • Must use Arduino or ESP32",
            difficulty: .intermediate,
            category: .electronics
        ),
        DesignChallenge(
            title: "The Accessible Gripper",
            description: "Design a 3D-printed adaptive tool gripper for people with limited hand mobility. It should allow users to securely hold screwdrivers, paintbrushes, or similar tools.",
            constraint: "Print time: Under 4 hours • One-handed operation",
            difficulty: .intermediate,
            category: .accessible
        ),
        DesignChallenge(
            title: "Flat-Pack Furniture Challenge",
            description: "Create a piece of furniture that ships completely flat and assembles without any tools, screws, or glue. Consider chairs, tables, or shelving units.",
            constraint: "Material: 1/2\" plywood only • Assembly time: Under 5 minutes",
            difficulty: .advanced,
            category: .furniture
        ),
        DesignChallenge(
            title: "LED Wearable Art",
            description: "Design a wearable piece that incorporates programmable LEDs and responds to movement or sound. Think beyond simple blinking patterns.",
            constraint: "Battery life: Min 4 hours • Comfortable to wear",
            difficulty: .advanced,
            category: .wearable
        ),
        DesignChallenge(
            title: "The Parametric Lamp",
            description: "Design a laser-cut lamp shade using parametric design principles. The pattern should create interesting light and shadow effects while being structurally sound.",
            constraint: "Material: 1/8\" plywood or acrylic • No adhesives",
            difficulty: .intermediate,
            category: .fabrication
        ),
        DesignChallenge(
            title: "Urban Garden Planter",
            description: "Create a self-watering planter system for small urban spaces. It should hold at least 3 different plants and include a water reservoir that lasts one week.",
            constraint: "Footprint: Max 18\" x 12\" • Food-safe materials",
            difficulty: .beginner,
            category: .sustainable
        ),
        DesignChallenge(
            title: "Workshop Clamp Rack",
            description: "Design an efficient storage solution for 10+ clamps of various sizes. It should be quick to access, space-efficient, and keep clamps organized by size.",
            constraint: "Wall-mounted or mobile • Budget: Under $15",
            difficulty: .beginner,
            category: .tools
        ),
        DesignChallenge(
            title: "The Sound Reactive Display",
            description: "Build an audio-responsive visual display using an FFT analysis of sound input. Create mesmerizing patterns that dance to music or ambient noise.",
            constraint: "Real-time response • 60+ FPS animation",
            difficulty: .advanced,
            category: .electronics
        )
    ]
    
    static var randomCurated: DesignChallenge {
        curatedChallenges.randomElement() ?? curatedChallenges[0]
    }
}
