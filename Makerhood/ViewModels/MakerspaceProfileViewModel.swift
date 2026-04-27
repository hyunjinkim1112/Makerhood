//
//  MakerspaceProfileViewModel.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 23/4/26.
//

import Foundation
import FirebaseFirestore
import Combine 

@MainActor
class MakerspaceProfileViewModel: ObservableObject {
    @Published var makerspace: Makerspace?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    // MARK: - Load Makerspace Profile
    
    func loadMakerspaceProfile(userId: String?) async {
        guard let userId = userId else {
            errorMessage = "User ID not found"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let document = try await db.collection("makerspaces").document(userId).getDocument()
            
            guard document.exists,
                  let data = document.data(),
                  let makerspace = Makerspace.fromDictionary(data, id: userId) else {
                errorMessage = "Makerspace profile not found"
                isLoading = false
                return
            }
            
            self.makerspace = makerspace
            print("✅ Makerspace profile loaded: \(makerspace.name)")
        } catch {
            errorMessage = "Failed to load makerspace profile: \(error.localizedDescription)"
            print("❌ Error loading makerspace: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Update Makerspace
    
    func updateMakerspace(_ makerspace: Makerspace) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let data: [String: Any] = [
                "name": makerspace.name,
                "description": makerspace.description,
                "address": makerspace.address,
                "latitude": makerspace.latitude,
                "longitude": makerspace.longitude,
                "imageURL": makerspace.imageURL as Any,
                "websiteURL": makerspace.websiteURL as Any,
                "organizationId": makerspace.organizationId,
                "createdAt": makerspace.createdAt?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
            ]
            
            try await db.collection("makerspaces").document(makerspace.id).setData(data, merge: true)
            
            self.makerspace = makerspace
            print("✅ Makerspace profile updated successfully")
        } catch {
            errorMessage = "Failed to update makerspace: \(error.localizedDescription)"
            print("❌ Error updating makerspace: \(error)")
        }
        
        isLoading = false
    }
}
