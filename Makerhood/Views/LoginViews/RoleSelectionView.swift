//
//  RoleSelectionView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import SwiftUI

enum UserRole {
    case user
    case organization
}

struct RoleSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedRole: UserRole?
    @Binding var showSignUp: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("Welcome to Makerhood")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Choose your account type")
                .font(.title3)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            VStack(spacing: 20) {
                // User Button
                Button(action: {
                    selectedRole = .user
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showSignUp = true
                    }
                }) {
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("I'm a User")
                                .font(.headline)
                            Text("Access makerspaces and workshops")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.makerYellow, lineWidth: 2)
                    )
                }
                .foregroundStyle(.primary)
                
                // Organization Button
                Button(action: {
                    selectedRole = .organization
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showSignUp = true
                    }
                }) {
                    HStack {
                        Image(systemName: "building.2.fill")
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("I'm a Makerspace")
                                .font(.headline)
                            Text("Manage your makerspace")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.makerYellow, lineWidth: 2)
                    )
                }
                .foregroundStyle(.primary)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            // Login link for existing users
            HStack {
                Text("Already have an account?")
                    .foregroundStyle(.secondary)
                Button("Log In") {
                    dismiss()
                }
                .fontWeight(.semibold)
            }
            .padding(.bottom, 30)
        }
        .background(Color.makerYellow.opacity(0.1))
    }
}

#Preview {
    RoleSelectionView(selectedRole: .constant(nil), showSignUp: .constant(false))
}
