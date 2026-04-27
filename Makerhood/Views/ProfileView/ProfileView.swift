//
//  ProfileView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import SwiftUI
import Combine

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showEditProfile = false
    
    var body: some View {
        // Check user role and show appropriate profile
        if authViewModel.currentUser?.role == "organization" {
            MakerspaceProfileView()
        } else {
            userProfileView
        }
    }
    
    // MARK: - User Profile View
    
    private var userProfileView: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Card
                    profileHeaderCard
                    
                    // Sign Out Button
                    signOutButton
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
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
                EditProfileView()
            }
        }
    }
    
    // MARK: - Profile Header Card
    
    private var profileHeaderCard: some View {
        VStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.makerYellow.opacity(0.6), Color.makerYellow.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .overlay(
                    Text(authViewModel.currentUser?.fullName.prefix(1).uppercased() ?? "?")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                )
                .shadow(color: Color.makerYellow.opacity(0.3), radius: 10, x: 0, y: 5)
            
            // Name
            Text(authViewModel.currentUser?.fullName ?? "Unknown User")
                .font(.title2)
                .fontWeight(.bold)
            
            // School & Major
            if let user = authViewModel.currentUser {
                if let school = user.school, let major = user.major {
                    Label("\(major) · \(school)", systemImage: "graduationcap.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else if let school = user.school {
                    Label(school, systemImage: "graduationcap.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Bio
            if let bio = authViewModel.currentUser?.bio {
                Text(bio)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Stats Row
            HStack(spacing: 40) {
                StatItem(
                    value: "\(authViewModel.currentUser?.email.prefix(1).uppercased() ?? "0")",
                    label: "Member",
                    icon: "person.fill"
                )
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
        .padding(.horizontal)
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
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.red)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

// MARK: - Stat Item

struct StatItem: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.makerYellow)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Project Card

struct ProjectCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray5))
                .frame(width: 160, height: 120)
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                )
            
            Text("Project Name")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text("2 weeks ago")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: 160)
    }
}

// MARK: - Edit Profile View

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var bio = ""
    @State private var school = ""
    @State private var major = ""
    @State private var skills: [String] = []
    @State private var newSkill = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("About") {
                    TextField("Bio", text: $bio, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Education") {
                    TextField("School", text: $school)
                    TextField("Major", text: $major)
                }
            
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveProfile()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            loadCurrentData()
        }
    }
    
    private func loadCurrentData() {
        if let user = authViewModel.currentUser {
            bio = user.bio ?? ""
            school = user.school ?? ""
            major = user.major ?? ""
            skills = user.skills ?? []
        }
    }
    
    private func saveProfile() {
        // TODO: Save to Firebase
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject({
                let vm = AuthViewModel()
                vm.currentUser = User.sample
                vm.isAuthenticated = true
                return vm
            }())
    }
}
