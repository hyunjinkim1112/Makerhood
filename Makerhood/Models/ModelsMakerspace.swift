//
//  Makerspace.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import Foundation
import CoreLocation

struct Makerspace: Identifiable, Codable, Hashable {
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
            name: "MIT Makerspace",
            description: "State-of-the-art makerspace with advanced fabrication tools",
            address: "77 Massachusetts Ave, Cambridge, MA",
            latitude: 42.3601,
            longitude: -71.0942,
            imageURL: nil,
            organizationId: "org1",
            amenities: ["3D Printer", "Laser Cutter", "CNC Mill", "Electronics Lab"],
            pricePerHour: 30.0,
            rating: 4.8,
            reviewCount: 245,
            isPopular: true,
            createdAt: Date()
        )
    }
    
    static var samples: [Makerspace] {
        [
            Makerspace(
                id: "1",
                name: "MIT Makerspace",
                description: "State-of-the-art makerspace with advanced fabrication tools",
                address: "77 Massachusetts Ave, Cambridge, MA",
                latitude: 42.3601,
                longitude: -71.0942,
                imageURL: nil,
                organizationId: "org1",
                amenities: ["3D Printer", "Laser Cutter", "CNC Mill", "Electronics Lab"],
                pricePerHour: 30.0,
                rating: 4.8,
                reviewCount: 245,
                isPopular: true,
                createdAt: Date()
            ),
            Makerspace(
                id: "2",
                name: "BC Fab Lab",
                description: "Community-focused fabrication laboratory",
                address: "140 Commonwealth Ave, Chestnut Hill, MA",
                latitude: 42.3355,
                longitude: -71.1685,
                imageURL: nil,
                organizationId: "org2",
                amenities: ["Woodworking", "3D Printer", "Soldering Station"],
                pricePerHour: 22.0,
                rating: 4.5,
                reviewCount: 128,
                isPopular: true,
                createdAt: Date()
            ),
            Makerspace(
                id: "3",
                name: "South End Studio",
                description: "Creative workspace in the heart of Boston",
                address: "550 Tremont St, Boston, MA",
                latitude: 42.3467,
                longitude: -71.0707,
                imageURL: nil,
                organizationId: "org3",
                amenities: ["Laser Cutter", "Vinyl Cutter", "Screen Printing"],
                pricePerHour: 25.0,
                rating: 4.2,
                reviewCount: 87,
                isPopular: false,
                createdAt: Date()
            ),
            Makerspace(
                id: "4",
                name: "TechHub Makerspace",
                description: "Modern makerspace with cutting-edge tools",
                address: "Innovation District, Boston, MA",
                latitude: 42.3520,
                longitude: -71.0447,
                imageURL: nil,
                organizationId: "org4",
                amenities: ["3D Printer", "Laser Cutter", "Electronics"],
                pricePerHour: 28.0,
                rating: 4.7,
                reviewCount: 156,
                isPopular: true,
                createdAt: Date()
            ),
            Makerspace(
                id: "5",
                name: "Cambridge Maker Collective",
                description: "Collaborative space for makers and creators",
                address: "Central Square, Cambridge, MA",
                latitude: 42.3656,
                longitude: -71.1040,
                imageURL: nil,
                organizationId: "org5",
                amenities: ["Woodworking", "Metal Shop", "CNC Router"],
                pricePerHour: 20.0,
                rating: 4.6,
                reviewCount: 92,
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
