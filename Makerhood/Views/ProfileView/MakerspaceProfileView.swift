//
//  MakerspaceProfileView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 23/4/26.
//

import SwiftUI
import FirebaseFirestore

struct MakerspaceProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = MakerspaceProfileViewModel()
    @State private var showEditProfile = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let makerspace = viewModel.makerspace {
                        // Header Section
                        makerspaceHeaderCard(makerspace: makerspace)
                       
                    } else if viewModel.isLoading {
                        ProgressView("Loading makerspace profile...")
                            .padding()
                    } else {
                        emptyStateView
                    }
                    
                    // Sign Out Button
                    signOutButton
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Makerspace Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        showEditProfile = true
                    }
                    .foregroundStyle(.makerYellow)
                }
            }
            .sheet(isPresented: $showEditProfile) {
                if let makerspace = viewModel.makerspace {
                    EditMakerspaceProfileView(makerspace: makerspace) { updatedMakerspace in
                        Task {
                            await viewModel.updateMakerspace(updatedMakerspace)
                        }
                    }
                }
            }
            .alert("Error", isPresented: .init(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
        .task {
            await viewModel.loadMakerspaceProfile(userId: authViewModel.currentUser?.id)
        }
    }
    
    // MARK: - Header Card
    
    private func makerspaceHeaderCard(makerspace: Makerspace) -> some View {
        VStack(spacing: 16) {
            // Image or Placeholder
            if let imageURL = makerspace.imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    placeholderImage
                }
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)
            } else {
                placeholderImage
            }
            
            // Name
            Text(makerspace.name)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private var placeholderImage: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(
                    colors: [Color.makerYellow.opacity(0.6), Color.makerYellow.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 120, height: 120)
            .overlay(
                Image(systemName: "building.2.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.white)
            )
            .shadow(radius: 5)
    }
    
    
  
    
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "building.2")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("Makerspace Profile Not Found")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("There was an issue loading your makerspace profile. Please try signing out and signing in again.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding()
    }
    
    // MARK: - Sign Out Button
    
    private var signOutButton: some View {
        Button(action: {
            authViewModel.signOut()
        }) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Sign Out")
            }
            .fontWeight(.semibold)
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

// MARK: - Stat Card Component

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.makerYellow)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    MakerspaceProfileView()
        .environmentObject(AuthViewModel())
}
