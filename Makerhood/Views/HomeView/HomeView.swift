//
//  HomeView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Welcome Header
                    welcomeHeader
                    
                    // Search Bar
                    searchBar
                    
                    // Nearby Spaces Section
                    nearbySection
                    
                    // Popular This Week Section
                    popularSection
                    
                    // Upcoming Bookings Section
                    if !viewModel.upcomingBookings.isEmpty {
                        upcomingBookingsSection
                    }
                }
                .padding(.vertical)
            }
            .refreshable {
                await refreshData()
            }
            .navigationTitle("Makerhood")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(.makerYellow)
                    }
                }
            }
        }
    }
    
    // MARK: - Welcome Header
    
    private var welcomeHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("👋 Hey \(authViewModel.currentUser?.fullName.components(separatedBy: " ").first ?? "there")")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Find your Makerspace")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("Search near you...", text: $searchText)
                .textFieldStyle(.plain)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    // MARK: - Nearby Section
    
    private var nearbySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundStyle(.makerYellow)
                Text("Nearby Spaces")
                    .font(.headline)
                
                Spacer()
                
                Button("See All") {
                    // Navigate to all nearby spaces
                }
                .font(.subheadline)
                .foregroundStyle(.makerYellow)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.nearbyMakerspaces) { makerspace in
                        MakerspaceCard(makerspace: makerspace)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Popular Section
    
    private var popularSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.makerYellow)
                Text("Popular This Week")
                    .font(.headline)
                
                Spacer()
                
                Button("See All") {
                    // Navigate to all popular spaces
                }
                .font(.subheadline)
                .foregroundStyle(.makerYellow)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.popularMakerspaces) { makerspace in
                        MakerspaceCard(makerspace: makerspace)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Upcoming Bookings Section
    
    private var upcomingBookingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(.makerYellow)
                Text("Your Upcoming Bookings")
                    .font(.headline)
                
                Spacer()
                
                Button("View All") {
                    // Navigate to all bookings
                }
                .font(.subheadline)
                .foregroundStyle(.makerYellow)
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(viewModel.upcomingBookings.prefix(3)) { booking in
                    BookingCard(booking: booking)
                        .padding(.horizontal)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func refreshData() async {
        guard let userId = authViewModel.currentUser?.id else { return }
        await viewModel.refreshAllData(userId: userId)
    }
}

// MARK: - Makerspace Card

struct MakerspaceCard: View {
    let makerspace: Makerspace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image Placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [.makerYellow.opacity(0.3), .makerYellow.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 280, height: 160)
                
                Image(systemName: "hammer.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(makerspace.name)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.makerYellow)
                    Text(String(format: "%.1f", makerspace.rating))
                        .font(.caption)
                    Text("(\(makerspace.reviewCount))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(makerspace.address)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Text("$\(Int(makerspace.pricePerHour))/hr")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.makerYellow)
                    
                    Spacer()
                    
                    if makerspace.isPopular {
                        HStack(spacing: 2) {
                            Image(systemName: "flame.fill")
                                .font(.caption2)
                            Text("Popular")
                                .font(.caption2)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.makerYellow)
                        .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(width: 280)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Booking Card

struct BookingCard: View {
    let booking: Booking
    
    var body: some View {
        HStack(spacing: 12) {
            // Date Badge
            VStack(spacing: 2) {
                Text(booking.startTime.formatted(.dateTime.month(.abbreviated)))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(booking.startTime.formatted(.dateTime.day()))
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .frame(width: 50, height: 50)
            .background(Color.makerYellow.opacity(0.2))
            .cornerRadius(10)
            
            // Booking Info
            VStack(alignment: .leading, spacing: 4) {
                Text(booking.makerspaceName)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text("\(booking.startTime.formatted(.dateTime.hour().minute())) - \(booking.endTime.formatted(.dateTime.hour().minute()))")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
                
                Text("$\(Int(booking.totalPrice))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.makerYellow)
            }
            
            Spacer()
            
            // Status Badge
            statusBadge
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var statusBadge: some View {
        Group {
            switch booking.status {
            case .confirmed:
                Label("Confirmed", systemImage: "checkmark.circle.fill")
                    .font(.caption2)
                    .foregroundStyle(.green)
            case .pending:
                Label("Pending", systemImage: "clock.fill")
                    .font(.caption2)
                    .foregroundStyle(.orange)
            case .cancelled:
                Label("Cancelled", systemImage: "xmark.circle.fill")
                    .font(.caption2)
                    .foregroundStyle(.red)
            case .completed:
                Label("Completed", systemImage: "checkmark.circle.fill")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
        }
        .labelStyle(.iconOnly)
    }
}

// MARK: - Preview

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
