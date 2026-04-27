//
//  HomeViewModel.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import CoreLocation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var nearbyMakerspaces: [Makerspace] = []
    @Published var popularMakerspaces: [Makerspace] = []
    @Published var upcomingBookings: [Booking] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    init() {
        // Load sample data initially
        loadSampleData()
    }
    
    // MARK: - Load Sample Data
    
    func loadSampleData() {
        nearbyMakerspaces = Makerspace.samples
        popularMakerspaces = Makerspace.samples.filter { $0.isPopular }
        upcomingBookings = Booking.samples
    }
    
    // MARK: - Fetch Nearby Makerspaces
    
    func fetchNearbyMakerspaces(userLocation: CLLocationCoordinate2D? = nil, radius: Double = 10.0) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // TODO: Implement geohash queries for location-based search
            // For now, fetch all makerspaces
            let snapshot = try await db.collection("makerspaces")
                .limit(to: 10)
                .getDocuments()
            
            let makerspaces = snapshot.documents.compactMap { doc -> Makerspace? in
                Makerspace.fromDictionary(doc.data(), id: doc.documentID)
            }
            
            // If user location is provided, sort by distance
            if let userLocation = userLocation {
                nearbyMakerspaces = makerspaces.sorted { space1, space2 in
                    let distance1 = calculateDistance(from: userLocation, to: space1.coordinate)
                    let distance2 = calculateDistance(from: userLocation, to: space2.coordinate)
                    return distance1 < distance2
                }
            } else {
                nearbyMakerspaces = makerspaces
            }
            
        } catch {
            errorMessage = "Failed to fetch nearby makerspaces"
            print("Error fetching nearby makerspaces: \(error.localizedDescription)")
            // Fallback to sample data
            nearbyMakerspaces = Makerspace.samples
        }
        
        isLoading = false
    }
    
    // MARK: - Fetch Popular Makerspaces
    
    func fetchPopularMakerspaces() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let snapshot = try await db.collection("makerspaces")
                .whereField("isPopular", isEqualTo: true)
                .order(by: "rating", descending: true)
                .limit(to: 10)
                .getDocuments()
            
            popularMakerspaces = snapshot.documents.compactMap { doc -> Makerspace? in
                Makerspace.fromDictionary(doc.data(), id: doc.documentID)
            }
            
        } catch {
            errorMessage = "Failed to fetch popular makerspaces"
            print("Error fetching popular makerspaces: \(error.localizedDescription)")
            // Fallback to sample data
            popularMakerspaces = Makerspace.samples.filter { $0.isPopular }
        }
        
        isLoading = false
    }
    
    // MARK: - Fetch Upcoming Bookings
    
    func fetchUpcomingBookings(userId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let currentTime = Date().timeIntervalSince1970
            
            let snapshot = try await db.collection("bookings")
                .whereField("userId", isEqualTo: userId)
                .whereField("startTime", isGreaterThan: currentTime)
                .whereField("status", isEqualTo: BookingStatus.confirmed.rawValue)
                .order(by: "startTime")
                .limit(to: 5)
                .getDocuments()
            
            upcomingBookings = snapshot.documents.compactMap { doc -> Booking? in
                Booking.fromDictionary(doc.data(), id: doc.documentID)
            }
            
        } catch {
            errorMessage = "Failed to fetch bookings"
            print("Error fetching bookings: \(error.localizedDescription)")
            // Fallback to sample data
            upcomingBookings = Booking.samples
        }
        
        isLoading = false
    }
    
    // MARK: - Refresh All Data
    
    func refreshAllData(userId: String, userLocation: CLLocationCoordinate2D? = nil) async {
        await fetchNearbyMakerspaces(userLocation: userLocation)
        await fetchPopularMakerspaces()
        await fetchUpcomingBookings(userId: userId)
    }
    
    // MARK: - Search Makerspaces
    
    func searchMakerspaces(query: String) async {
        guard !query.isEmpty else {
            await fetchNearbyMakerspaces()
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Note: Firestore doesn't support full-text search natively
            // This is a basic implementation - consider using Algolia or similar for production
            let snapshot = try await db.collection("makerspaces")
                .whereField("name", isGreaterThanOrEqualTo: query)
                .whereField("name", isLessThan: query + "\u{f8ff}")
                .limit(to: 20)
                .getDocuments()
            
            nearbyMakerspaces = snapshot.documents.compactMap { doc -> Makerspace? in
                Makerspace.fromDictionary(doc.data(), id: doc.documentID)
            }
            
        } catch {
            errorMessage = "Search failed"
            print("Error searching makerspaces: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Helper Methods
    
    private func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation) // Returns distance in meters
    }
    
    func distanceString(from userLocation: CLLocationCoordinate2D, to makerspace: Makerspace) -> String {
        let distance = calculateDistance(from: userLocation, to: makerspace.coordinate)
        let distanceInKm = distance / 1000.0
        
        if distanceInKm < 1.0 {
            return String(format: "%.0f m", distance)
        } else {
            return String(format: "%.1f km", distanceInKm)
        }
    }
}
