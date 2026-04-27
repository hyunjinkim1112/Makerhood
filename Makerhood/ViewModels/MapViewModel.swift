//
//  MapViewModel.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import Foundation
import Combine
import FirebaseFirestore
import MapKit

@MainActor
class MapViewModel: ObservableObject {
    @Published var makerspaces: [Makerspace] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    /// Fetch all makerspaces from Firebase
    func fetchMakerspaces() async {
        isLoading = true
        errorMessage = nil
        
        print("🔍 [MapViewModel] Starting to fetch makerspaces from Firebase...")
        
        do {
            let snapshot = try await db.collection("makerspaces")
                .getDocuments()
            
            print("✅ [MapViewModel] Successfully fetched \(snapshot.documents.count) documents from Firebase")
            
            makerspaces = snapshot.documents.compactMap { doc in
                print("📄 [MapViewModel] Processing document ID: \(doc.documentID)")
                print("📄 [MapViewModel] Document data: \(doc.data())")
                
                let makerspace = Makerspace.fromDictionary(doc.data(), id: doc.documentID)
                if makerspace == nil {
                    print("⚠️ [MapViewModel] Failed to parse document \(doc.documentID)")
                } else {
                    print("✅ [MapViewModel] Successfully parsed: \(makerspace!.name)")
                }
                return makerspace
            }
            
            print("✅ [MapViewModel] Total makerspaces parsed: \(makerspaces.count)")
            
            if makerspaces.isEmpty {
                print("⚠️ [MapViewModel] No makerspaces found in Firebase, using sample data")
                makerspaces = Makerspace.samples
            }
            
        } catch {
            errorMessage = "Failed to fetch makerspaces: \(error.localizedDescription)"
            print("❌ [MapViewModel] Error fetching makerspaces: \(error)")
            print("❌ [MapViewModel] Error details: \(error.localizedDescription)")
            // Fallback to sample data on error
            makerspaces = Makerspace.samples
        }
        
        isLoading = false
        print("🏁 [MapViewModel] Fetch complete. isLoading: \(isLoading), makerspaces count: \(makerspaces.count)")
    }
    
    /// Fetch makerspaces within a specific map region
    /// Note: For production, consider implementing geohash queries for better performance
    func fetchMakerspaces(in region: MKCoordinateRegion) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Calculate bounding box for the visible region
            let minLat = region.center.latitude - region.span.latitudeDelta / 2
            let maxLat = region.center.latitude + region.span.latitudeDelta / 2
            let minLon = region.center.longitude - region.span.longitudeDelta / 2
            let maxLon = region.center.longitude + region.span.longitudeDelta / 2
            
            // Fetch makerspaces within latitude bounds
            // Note: This is a simplified query. For production, use geohash for better performance
            let snapshot = try await db.collection("makerspaces")
                .whereField("latitude", isGreaterThanOrEqualTo: minLat)
                .whereField("latitude", isLessThanOrEqualTo: maxLat)
                .getDocuments()
            
            // Filter by longitude in-memory (Firestore limitation: can't query two ranges)
            makerspaces = snapshot.documents.compactMap { doc in
                Makerspace.fromDictionary(doc.data(), id: doc.documentID)
            }.filter { makerspace in
                makerspace.longitude >= minLon && makerspace.longitude <= maxLon
            }
            
            if makerspaces.isEmpty {
                print("No makerspaces found in this region")
            }
            
        } catch {
            errorMessage = "Failed to fetch makerspaces: \(error.localizedDescription)"
            print("Error fetching makerspaces for region: \(error)")
        }
        
        isLoading = false
    }
}
