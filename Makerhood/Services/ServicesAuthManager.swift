//
//  AuthenticationManager.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthError: LocalizedError {
    case userNotFound
    case invalidCredentials
    case networkError
    case emailAlreadyInUse
    case weakPassword
    case invalidEmail
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found. Please check your credentials."
        case .invalidCredentials:
            return "Invalid email or password."
        case .networkError:
            return "Network error. Please check your connection."
        case .emailAlreadyInUse:
            return "This email is already registered."
        case .weakPassword:
            return "Password should be at least 6 characters."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .unknown(let message):
            return message
        }
    }
}

@MainActor
class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {}
    
    var currentUser: FirebaseAuth.User? {
        auth.currentUser
    }
    
    var isAuthenticated: Bool {
        auth.currentUser != nil
    }
    
    // MARK: - Sign Up
    
    func signUp(email: String, password: String, userData: [String: Any]) async throws -> User {
        do {
            let authResult = try await auth.createUser(withEmail: email, password: password)
            
            // Create user document in Firestore
            var userDict = userData
            userDict["createdAt"] = Date().timeIntervalSince1970
            
            print("📝 Creating Firestore document for UID: \(authResult.user.uid)")
            print("📝 Data to be saved: \(userDict)")
            
            try await db.collection("users").document(authResult.user.uid).setData(userDict)
            
            print("✅ Firestore document created successfully")
            
            guard let user = User.fromDictionary(userDict, id: authResult.user.uid) else {
                print("❌ Failed to create user from dictionary: \(userDict)")
                throw AuthError.unknown("Failed to create user profile")
            }
            
            return user
        } catch let error as NSError {
            print("❌ Sign up error: \(error.localizedDescription)")
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Sign In
    
    func signIn(email: String, password: String) async throws -> User {
        do {
            let authResult = try await auth.signIn(withEmail: email, password: password)
            
            // Fetch user data from Firestore
            let document = try await db.collection("users").document(authResult.user.uid).getDocument()
            
            // If document doesn't exist, create a basic one as a fallback
            if !document.exists {
                print("⚠️ Firestore document does not exist for UID: \(authResult.user.uid)")
                print("📝 Creating basic user document as fallback...")
                
                // Create basic user data from Firebase Auth
                let basicUserData: [String: Any] = [
                    "email": authResult.user.email ?? email,
                    "fullName": authResult.user.displayName ?? "User",
                    "phoneNumber": authResult.user.phoneNumber ?? "",
                    "role": "user",
                    "createdAt": Date().timeIntervalSince1970
                ]
                
                try await db.collection("users").document(authResult.user.uid).setData(basicUserData)
                print("✅ Basic user document created successfully")
                
                guard let user = User.fromDictionary(basicUserData, id: authResult.user.uid) else {
                    throw AuthError.unknown("Failed to create user profile")
                }
                
                return user
            }
            
            guard let data = document.data() else {
                print("❌ Firestore document exists but has no data for UID: \(authResult.user.uid)")
                throw AuthError.userNotFound
            }
            
            print("✅ Firestore data retrieved: \(data)")
            
            guard let user = User.fromDictionary(data, id: authResult.user.uid) else {
                print("❌ Failed to parse user from dictionary. Data: \(data)")
                throw AuthError.unknown("Failed to parse user data")
            }
            
            print("✅ User successfully created from Firestore data")
            return user
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Sign Out
    
    func signOut() throws {
        do {
            try auth.signOut()
        } catch {
            throw AuthError.unknown("Failed to sign out")
        }
    }
    
    // MARK: - Fetch User Data
    
    func fetchUserData(uid: String) async throws -> User {
        do {
            let document = try await db.collection("users").document(uid).getDocument()
            
            // If document doesn't exist, try to create a basic one from Firebase Auth
            if !document.exists {
                print("⚠️ Firestore document missing for UID: \(uid)")
                
                if let firebaseUser = auth.currentUser, firebaseUser.uid == uid {
                    print("📝 Creating basic user document from Firebase Auth data...")
                    
                    let basicUserData: [String: Any] = [
                        "email": firebaseUser.email ?? "",
                        "fullName": firebaseUser.displayName ?? "User",
                        "phoneNumber": firebaseUser.phoneNumber ?? "",
                        "role": "user",
                        "createdAt": Date().timeIntervalSince1970
                    ]
                    
                    try await db.collection("users").document(uid).setData(basicUserData)
                    
                    guard let user = User.fromDictionary(basicUserData, id: uid) else {
                        throw AuthError.unknown("Failed to create user profile")
                    }
                    
                    return user
                }
                
                throw AuthError.userNotFound
            }
            
            guard let data = document.data(),
                  let user = User.fromDictionary(data, id: uid) else {
                throw AuthError.userNotFound
            }
            
            return user
        } catch {
            throw AuthError.unknown("Failed to fetch user data")
        }
    }
    
    // MARK: - Password Reset
    
    func resetPassword(email: String) async throws {
        do {
            try await auth.sendPasswordReset(withEmail: email)
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Helper Methods
    
    private func mapFirebaseError(_ error: NSError) -> AuthError {
        guard let errorCode = AuthErrorCode(_bridgedNSError: error) else {
            return .unknown(error.localizedDescription)
        }
        
        switch errorCode.code {
        case .userNotFound:
            return .userNotFound
        case .wrongPassword, .invalidCredential:
            return .invalidCredentials
        case .networkError:
            return .networkError
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .weakPassword:
            return .weakPassword
        case .invalidEmail:
            return .invalidEmail
        default:
            return .unknown(error.localizedDescription)
        }
    }
}
