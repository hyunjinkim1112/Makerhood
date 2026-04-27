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
    let websiteURL: String?
    let organizationId: String
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
            imageURL: "https://content.civicplus.com/api/assets/ma-watertown/38f284d6-3d56-41bd-912a-fbcc0a3ac54f?cache=1800&width=1540&mode=min",
            websiteURL: "https://makemit.mit.edu",
            organizationId: "org1",
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
                imageURL: "https://content.civicplus.com/api/assets/ma-watertown/38f284d6-3d56-41bd-912a-fbcc0a3ac54f?cache=1800&width=1540&mode=min",
                websiteURL: "https://www.watertownlib.org/707/Hatch-Makerspace",
                organizationId: "org1",
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
                websiteURL: "https://www.bc.edu/fablab",
                organizationId: "org2",
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
                websiteURL: "https://www.southendstudio.com",
                organizationId: "org3",
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
                websiteURL: "https://www.techhubboston.com",
                organizationId: "org4",
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
                websiteURL: "https://www.cambridgemakers.org",
                organizationId: "org5",
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
              let organizationId = dict["organizationId"] as? String else {
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
            websiteURL: dict["websiteURL"] as? String,
            organizationId: organizationId,
            createdAt: createdAt
        )
    }
}
