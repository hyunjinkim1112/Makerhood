//
//  Workshop.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import Foundation

enum WorkshopCategory: String, Codable, CaseIterable {
    case woodworking = "Woodworking"
    case electronics = "Electronics"
    case printing3D = "3D Printing"
    case laserCutting = "Laser Cutting"
    case metalworking = "Metalworking"
    case textiles = "Textiles"
    case coding = "Coding"
    case robotics = "Robotics"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .woodworking: return "hammer.fill"
        case .electronics: return "bolt.fill"
        case .printing3D: return "cube.fill"
        case .laserCutting: return "laser.burst"
        case .metalworking: return "wrench.and.screwdriver.fill"
        case .textiles: return "scissors"
        case .coding: return "chevron.left.forwardslash.chevron.right"
        case .robotics: return "gear.badge"
        case .other: return "star.fill"
        }
    }
}

enum WorkshopLevel: String, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case allLevels = "All Levels"
}

struct Workshop: Identifiable, Codable {
    let id: String
    let makerspaceId: String
    let makerspaceName: String
    let title: String
    let description: String
    let category: WorkshopCategory
    let level: WorkshopLevel
    let instructor: String
    let date: Date
    let duration: TimeInterval // in seconds
    let price: Double?
    let maxParticipants: Int?
    let websiteURL: String?
    let imageURL: String?
    let createdAt: Date?
    
    var durationHours: Double {
        duration / 3600
    }
    
    var isUpcoming: Bool {
        date > Date()
    }
    
    var isPast: Bool {
        date.addingTimeInterval(duration) < Date()
    }
    
    var formattedPrice: String {
        if let price = price {
            return price == 0 ? "Free" : "$\(String(format: "%.0f", price))"
        }
        return "Free"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var formattedDuration: String {
        let hours = Int(durationHours)
        let minutes = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)
        
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
    
    // MARK: - Sample Data
    
    static var sample: Workshop {
        Workshop(
            id: "1",
            makerspaceId: "1",
            makerspaceName: "MIT Makerspace",
            title: "Introduction to 3D Printing",
            description: "Learn the basics of 3D printing, from design to finished product. Perfect for beginners!",
            category: .printing3D,
            level: .beginner,
            instructor: "Sarah Chen",
            date: Date().addingTimeInterval(86400 * 3), // 3 days from now
            duration: 7200, // 2 hours
            price: 45.0,
            maxParticipants: 12,
            websiteURL: "https://mitmakerspace.com/workshops/3d-printing-intro",
            imageURL: nil,
            createdAt: Date()
        )
    }
    
    static var samples: [Workshop] {
        [
            Workshop(
                id: "1",
                makerspaceId: "1",
                makerspaceName: "MIT Makerspace",
                title: "Introduction to 3D Printing",
                description: "Learn the basics of 3D printing, from design to finished product. Perfect for beginners!",
                category: .printing3D,
                level: .beginner,
                instructor: "Sarah Chen",
                date: Date().addingTimeInterval(86400 * 3),
                duration: 7200,
                price: 45.0,
                maxParticipants: 12,
                websiteURL: "https://mitmakerspace.com/workshops/3d-printing-intro",
                imageURL: nil,
                createdAt: Date()
            ),
            Workshop(
                id: "2",
                makerspaceId: "2",
                makerspaceName: "BC Fab Lab",
                title: "Laser Cutting Masterclass",
                description: "Advanced laser cutting techniques for creating intricate designs and functional prototypes.",
                category: .laserCutting,
                level: .intermediate,
                instructor: "Michael Park",
                date: Date().addingTimeInterval(86400 * 5),
                duration: 10800,
                price: 60.0,
                maxParticipants: 8,
                websiteURL: "https://bcfablab.com/workshops/laser-cutting",
                imageURL: nil,
                createdAt: Date()
            ),
            Workshop(
                id: "3",
                makerspaceId: "3",
                makerspaceName: "South End Studio",
                title: "Arduino for Beginners",
                description: "Build your first Arduino project! No prior experience needed.",
                category: .electronics,
                level: .beginner,
                instructor: "James Rodriguez",
                date: Date().addingTimeInterval(86400 * 7),
                duration: 5400,
                price: 0,
                maxParticipants: 15,
                websiteURL: "https://southendstudio.com/free-arduino-workshop",
                imageURL: nil,
                createdAt: Date()
            ),
            Workshop(
                id: "4",
                makerspaceId: "4",
                makerspaceName: "TechHub Makerspace",
                title: "Woodworking Fundamentals",
                description: "Master essential woodworking skills including measuring, cutting, joining, and finishing.",
                category: .woodworking,
                level: .allLevels,
                instructor: "Emily Davis",
                date: Date().addingTimeInterval(86400 * 10),
                duration: 14400,
                price: 75.0,
                maxParticipants: 10,
                websiteURL: "https://techhub.com/workshops/woodworking",
                imageURL: nil,
                createdAt: Date()
            ),
            Workshop(
                id: "5",
                makerspaceId: "5",
                makerspaceName: "Cambridge Maker Collective",
                title: "CNC Machining Workshop",
                description: "Learn to operate CNC mills and routers for precision manufacturing.",
                category: .metalworking,
                level: .advanced,
                instructor: "David Kim",
                date: Date().addingTimeInterval(86400 * 14),
                duration: 10800,
                price: 85.0,
                maxParticipants: 6,
                websiteURL: "https://cambridgemakers.com/cnc-workshop",
                imageURL: nil,
                createdAt: Date()
            ),
            Workshop(
                id: "6",
                makerspaceId: "1",
                makerspaceName: "MIT Makerspace",
                title: "Wearable Electronics",
                description: "Create interactive clothing and accessories with LED circuits and sensors.",
                category: .textiles,
                level: .intermediate,
                instructor: "Lisa Wang",
                date: Date().addingTimeInterval(86400 * 12),
                duration: 9000,
                price: 50.0,
                maxParticipants: 12,
                websiteURL: "https://mitmakerspace.com/workshops/wearables",
                imageURL: nil,
                createdAt: Date()
            )
        ]
    }
}

extension Workshop {
    static func fromDictionary(_ dict: [String: Any], id: String) -> Workshop? {
        guard let makerspaceId = dict["makerspaceId"] as? String,
              let makerspaceName = dict["makerspaceName"] as? String,
              let title = dict["title"] as? String,
              let description = dict["description"] as? String,
              let categoryString = dict["category"] as? String,
              let category = WorkshopCategory(rawValue: categoryString),
              let levelString = dict["level"] as? String,
              let level = WorkshopLevel(rawValue: levelString),
              let instructor = dict["instructor"] as? String,
              let dateTimestamp = dict["date"] as? Double,
              let duration = dict["duration"] as? TimeInterval else {
            return nil
        }
        
        let createdAt: Date? = {
            if let timestamp = dict["createdAt"] as? Double {
                return Date(timeIntervalSince1970: timestamp)
            }
            return nil
        }()
        
        return Workshop(
            id: id,
            makerspaceId: makerspaceId,
            makerspaceName: makerspaceName,
            title: title,
            description: description,
            category: category,
            level: level,
            instructor: instructor,
            date: Date(timeIntervalSince1970: dateTimestamp),
            duration: duration,
            price: dict["price"] as? Double,
            maxParticipants: dict["maxParticipants"] as? Int,
            websiteURL: dict["websiteURL"] as? String,
            imageURL: dict["imageURL"] as? String,
            createdAt: createdAt
        )
    }
}
