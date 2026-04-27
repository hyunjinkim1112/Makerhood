//
//  MakerspaceDetailView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct MakerspaceDetailView: View {
    let makerspace: Makerspace
    let geometry: GeometryProxy
    @Binding var selectedMakerspace: Makerspace?
    @Binding var bottomSheetHeight: CGFloat
    let minSheetHeight: CGFloat
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Close button
                HStack {
                    Text("Details")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            selectedMakerspace = nil
                            bottomSheetHeight = minSheetHeight
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .font(.title3)
                    }
                }
                .padding(.horizontal)
                
                // Image
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [.makerYellow.opacity(0.3), .makerYellow.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(height: 200)
                    
                    Image(systemName: "hammer.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(.horizontal)
                
                // Info
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(makerspace.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        if makerspace.isPopular {
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.caption)
                                Text("Popular")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.makerYellow)
                            .cornerRadius(12)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.makerYellow)
                        Text(String(format: "%.1f", makerspace.rating))
                            .fontWeight(.semibold)
                        Text("(\(makerspace.reviewCount) reviews)")
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundStyle(.makerYellow)
                        Text(makerspace.address)
                            .font(.subheadline)
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Price")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("$\(Int(makerspace.pricePerHour))/hr")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.makerYellow)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Navigate to booking
                        }) {
                            Text("Book Now")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 12)
                                .background(Color.makerYellow)
                                .cornerRadius(12)
                        }
                    }
                    
                    if !makerspace.amenities.isEmpty {
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Amenities")
                                .font(.headline)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(makerspace.amenities, id: \.self) { amenity in
                                    Text(amenity)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    // Recent Reviews Section
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Reviews")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button("See All") {
                                // Show all reviews
                            }
                            .font(.subheadline)
                            .foregroundStyle(.makerYellow)
                        }
                        
                        // Display reviews from posts
                        let reviews = Post.samples.filter { $0.makerspaceId == makerspace.id && $0.isReview }
                        
                        if reviews.isEmpty {
                            Text("No reviews yet. Be the first to review!")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 8)
                        } else {
                            ForEach(reviews.prefix(3)) { review in
                                MakerspaceReviewCard(review: review)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}
