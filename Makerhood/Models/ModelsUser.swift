//
//  User.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let fullName: String
    let phoneNumber: String
    let role: String // "user" or "organization"
    let createdAt: Date?
    
    // Optional fields for organization
    var organizationName: String?
    var contactName: String?
    var address: String?
    var website: String?
    
    // User profile fields
    var bio: String?
    var school: String?
    var major: String?
    var skills: [String]?
    var interests: [String]?
    var avatarURL: String?
}

extension User {
    static func fromDictionary(_ dict: [String: Any], id: String) -> User? {
        guard let email = dict["email"] as? String,
              let fullName = dict["fullName"] as? String,
              let phoneNumber = dict["phoneNumber"] as? String,
              let role = dict["role"] as? String else {
            return nil
        }
        
        // Make createdAt optional - handle legacy users without this field
        let createdAt: Date? = {
            if let timestamp = dict["createdAt"] as? Double {
                return Date(timeIntervalSince1970: timestamp)
            }
            return nil
        }()
        
        return User(
            id: id,
            email: email,
            fullName: fullName,
            phoneNumber: phoneNumber,
            role: role,
            createdAt: createdAt,
            organizationName: dict["organizationName"] as? String,
            contactName: dict["contactName"] as? String,
            address: dict["address"] as? String,
            website: dict["website"] as? String
        )
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "email": email,
            "fullName": fullName,
            "phoneNumber": phoneNumber,
            "role": role
        ]
        
        if let createdAt = createdAt {
            dict["createdAt"] = createdAt.timeIntervalSince1970
        }
        if let organizationName = organizationName {
            dict["organizationName"] = organizationName
        }
        if let contactName = contactName {
            dict["contactName"] = contactName
        }
        if let address = address {
            dict["address"] = address
        }
        if let website = website {
            dict["website"] = website
        }
        if let bio = bio {
            dict["bio"] = bio
        }
        if let school = school {
            dict["school"] = school
        }
        if let major = major {
            dict["major"] = major
        }
        if let skills = skills {
            dict["skills"] = skills
        }
        if let interests = interests {
            dict["interests"] = interests
        }
        if let avatarURL = avatarURL {
            dict["avatarURL"] = avatarURL
        }
        
        return dict
    }
    
    // Sample user for testing
    static var sample: User {
        User(
            id: "user1",
            email: "hyunjin@bc.edu",
            fullName: "Hyunjin Kim",
            phoneNumber: "+1 (617) 555-0123",
            role: "user",
            createdAt: Date().addingTimeInterval(-60 * 60 * 24 * 180),
            bio: "Passionate maker and student exploring the intersection of technology and design.",
            school: "Boston College",
            major: "Computer Science",
            skills: ["Electronics", "3D CAD", "Laser Cutting", "Arduino"],
            interests: ["Robotics", "IoT", "Wearables"]
        )
    }
}
