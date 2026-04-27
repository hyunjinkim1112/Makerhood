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
    let createdAt: Date
    
    // Optional fields for organization
    var organizationName: String?
    var contactName: String?
    var address: String?
    var website: String?
}

extension User {
    static func fromDictionary(_ dict: [String: Any], id: String) -> User? {
        guard let email = dict["email"] as? String,
              let fullName = dict["fullName"] as? String,
              let phoneNumber = dict["phoneNumber"] as? String,
              let role = dict["role"] as? String,
              let timestamp = dict["createdAt"] as? Double else {
            return nil
        }
        
        return User(
            id: id,
            email: email,
            fullName: fullName,
            phoneNumber: phoneNumber,
            role: role,
            createdAt: Date(timeIntervalSince1970: timestamp),
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
            "role": role,
            "createdAt": createdAt.timeIntervalSince1970
        ]
        
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
        
        return dict
    }
}
