//
//  Makerspace.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import Foundation
import CoreLocation

struct Makerspace: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let address: String
    let latitude: Double
    let longitude: Double
    let imageURL: String?
    let organizationId: String
    let amenities: [String]
    let pricePerHour: Double
    let rating: Double
    let reviewCount: Int
    let isPopular: Bool
    let createdAt: Date?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // For preview/mock data
    static var sample: Makerspace {
        Makerspace(
            id: "1",
            name: "TechHub Makerspace",
            description: "A modern makerspace with 3D printers, laser cutters, and more",
            address: "123 Innovation St, San Francisco, CA",
            latitude: 37.7749,
            longitude: -122.4194,
            imageURL: nil,
            organizationId: "org1",
            amenities: ["3D Printer", "Laser Cutter", "Woodworking"],
            pricePerHour: 25.0,
            rating: 4.8,
            reviewCount: 124,
            isPopular: true,
            createdAt: Date()
        )
    }
    
    static var samples: [Makerspace] {
        [
            Makerspace(
                id: "1",
                name: "TechHub Makerspace",
                description: "Modern makerspace with cutting-edge tools",
                address: "123 Innovation St, San Francisco, CA",
                latitude: 37.7749,
                longitude: -122.4194,
                imageURL: nil,
                organizationId: "org1",
                amenities: ["3D Printer", "Laser Cutter"],
                pricePerHour: 25.0,
                rating: 4.8,
                reviewCount: 124,
                isPopular: true,
                createdAt: Date()
            ),
            Makerspace(
                id: "2",
                name: "Creative Workshop",
                description: "Community-focused creative space",
                address: "456 Maker Ave, San Francisco, CA",
                latitude: 37.7849,
                longitude: -122.4294,
                imageURL: nil,
                organizationId: "org2",
                amenities: ["Woodworking", "Electronics"],
                pricePerHour: 20.0,
                rating: 4.5,
                reviewCount: 87,
                isPopular: true,
                createdAt: Date()
            ),
            Makerspace(
                id: "3",
                name: "Fab Lab",
                description: "Digital fabrication laboratory",
                address: "789 Build Rd, San Francisco, CA",
                latitude: 37.7649,
                longitude: -122.4094,
                imageURL: nil,
                organizationId: "org3",
                amenities: ["CNC Router", "3D Printer"],
                pricePerHour: 30.0,
                rating: 4.9,
                reviewCount: 203,
                isPopular: false,
                createdAt: Date()
            )
        ]
    }
}

extension Makerspace {
    static func fromDictionary(_ dict: [String: Any], id: String) -> Makerspace? {
        guard let name = dict["name"] as? String,
              let description = dict["description"] as? String,
              let address = dict["address"] as? String,
              let latitude = dict["latitude"] as? Double,
              let longitude = dict["longitude"] as? Double,
              let organizationId = dict["organizationId"] as? String,
              let amenities = dict["amenities"] as? [String],
              let pricePerHour = dict["pricePerHour"] as? Double,
              let rating = dict["rating"] as? Double,
              let reviewCount = dict["reviewCount"] as? Int,
              let isPopular = dict["isPopular"] as? Bool else {
            return nil
        }
        
        let createdAt: Date? = {
            if let timestamp = dict["createdAt"] as? Double {
                return Date(timeIntervalSince1970: timestamp)
            }
            return nil
        }()
        
        return Makerspace(
            id: id,
            name: name,
            description: description,
            address: address,
            latitude: latitude,
            longitude: longitude,
            imageURL: dict["imageURL"] as? String,
            organizationId: organizationId,
            amenities: amenities,
            pricePerHour: pricePerHour,
            rating: rating,
            reviewCount: reviewCount,
            isPopular: isPopular,
            createdAt: createdAt
        )
    }
}
