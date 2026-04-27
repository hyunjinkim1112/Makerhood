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
                        
                        // Information Section
                        informationSection(makerspace: makerspace)
                        
                        // Amenities Section
                        amenitiesSection(amenities: makerspace.amenities)
                        
                        // Pricing Section
                        pricingSection(price: makerspace.pricePerHour)
                        
                        // Stats Section
                        statsSection(makerspace: makerspace)
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
            
            // Rating
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text(String(format: "%.1f", makerspace.rating))
                    .fontWeight(.semibold)
                Text("(\(makerspace.reviewCount) reviews)")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
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
    
    // MARK: - Information Section
    
    private func informationSection(makerspace: Makerspace) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Information")
                .font(.headline)
            
            // Description
            VStack(alignment: .leading, spacing: 8) {
                Label("Description", systemImage: "text.alignleft")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(makerspace.description)
                    .font(.body)
            }
            
            // Address
            VStack(alignment: .leading, spacing: 8) {
                Label("Address", systemImage: "location.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(makerspace.address)
                    .font(.body)
            }
            
            // Contact (from user profile)
            if let user = authViewModel.currentUser {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Contact", systemImage: "phone.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(user.phoneNumber)
                        .font(.body)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Label("Email", systemImage: "envelope.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(user.email)
                        .font(.body)
                }
                
                if let website = user.website {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Website", systemImage: "globe")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Link(website, destination: URL(string: website) ?? URL(string: "https://example.com")!)
                            .font(.body)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    // MARK: - Amenities Section
    
    private func amenitiesSection(amenities: [String]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Amenities & Equipment")
                .font(.headline)
            
            if amenities.isEmpty {
                Text("No amenities added yet. Tap Edit to add your equipment.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                FlowLayout(spacing: 8) {
                    ForEach(amenities, id: \.self) { amenity in
                        Text(amenity)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.makerYellow.opacity(0.2))
                            .foregroundStyle(.primary)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    // MARK: - Pricing Section
    
    private func pricingSection(price: Double) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pricing")
                .font(.headline)
            
            HStack {
                Text("$\(Int(price))/hour")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.makerYellow)
                
                Spacer()
                
                if price == 0 {
                    Text("Set your pricing")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    // MARK: - Stats Section
    
    private func statsSection(makerspace: Makerspace) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.headline)
            
            HStack(spacing: 20) {
                StatCard(
                    title: "Reviews",
                    value: "\(makerspace.reviewCount)",
                    icon: "star.fill"
                )
                
                StatCard(
                    title: "Rating",
                    value: String(format: "%.1f", makerspace.rating),
                    icon: "chart.bar.fill"
                )
                
                StatCard(
                    title: "Popular",
                    value: makerspace.isPopular ? "Yes" : "No",
                    icon: "flame.fill"
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
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

// MARK: - Flow Layout for Amenities

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

// MARK: - Preview

#Preview {
    MakerspaceProfileView()
        .environmentObject(AuthViewModel())
}
