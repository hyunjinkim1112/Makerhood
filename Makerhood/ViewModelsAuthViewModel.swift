//
//  AuthViewModel.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authManager = AuthenticationManager.shared
    
    init() {
        checkAuthenticationState()
    }
    
    // MARK: - Check Auth State
    
    func checkAuthenticationState() {
        if let firebaseUser = authManager.currentUser {
            isAuthenticated = true
            
            // Fetch user data
            Task {
                do {
                    currentUser = try await authManager.fetchUserData(uid: firebaseUser.uid)
                } catch {
                    print("Error fetching user data: \(error.localizedDescription)")
                }
            }
        } else {
            isAuthenticated = false
            currentUser = nil
        }
    }
    
    // MARK: - Sign Up (User)
    
    func signUpUser(
        fullName: String,
        email: String,
        password: String,
        phoneNumber: String
    ) async {
        isLoading = true
        errorMessage = nil
        
        let userData: [String: Any] = [
            "email": email,
            "fullName": fullName,
            "phoneNumber": phoneNumber,
            "role": "user"
        ]
        
        do {
            currentUser = try await authManager.signUp(
                email: email,
                password: password,
                userData: userData
            )
            isAuthenticated = true
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "An unexpected error occurred"
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Up (Organization)
    
    func signUpOrganization(
        organizationName: String,
        contactName: String,
        email: String,
        password: String,
        phoneNumber: String,
        address: String,
        website: String?
    ) async {
        isLoading = true
        errorMessage = nil
        
        var userData: [String: Any] = [
            "email": email,
            "fullName": contactName,
            "phoneNumber": phoneNumber,
            "role": "organization",
            "organizationName": organizationName,
            "contactName": contactName,
            "address": address
        ]
        
        if let website = website, !website.isEmpty {
            userData["website"] = website
        }
        
        do {
            currentUser = try await authManager.signUp(
                email: email,
                password: password,
                userData: userData
            )
            isAuthenticated = true
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "An unexpected error occurred"
        }
        
        isLoading = false
    }
    
    // MARK: - Sign In
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            currentUser = try await authManager.signIn(email: email, password: password)
            isAuthenticated = true
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "An unexpected error occurred"
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        do {
            try authManager.signOut()
            currentUser = nil
            isAuthenticated = false
            errorMessage = nil
        } catch {
            errorMessage = "Failed to sign out"
        }
    }
    
    // MARK: - Password Reset
    
    func resetPassword(email: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authManager.resetPassword(email: email)
            isLoading = false
            return true
        } catch let error as AuthError {
            errorMessage = error.errorDescription
            isLoading = false
            return false
        } catch {
            errorMessage = "An unexpected error occurred"
            isLoading = false
            return false
        }
    }
    
    // MARK: - Clear Error
    
    func clearError() {
        errorMessage = nil
    }
}
