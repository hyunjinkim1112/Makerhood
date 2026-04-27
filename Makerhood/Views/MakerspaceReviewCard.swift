//
//  MakerspaceReviewCard.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct MakerspaceReviewCard: View {
    let review: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(Color.makerYellow.opacity(0.3))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text(review.userName.prefix(1))
                            .font(.subheadline)
                            .foregroundStyle(.makerYellow)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.userName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 4) {
                        if let rating = review.rating {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(rating) ? "star.fill" : "star")
                                    .font(.caption2)
                                    .foregroundStyle(.makerYellow)
                            }
                        }
                        
                        Text(review.createdAt.timeAgoDisplay())
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
            }
            
            Text(review.content)
                .font(.caption)
                .lineLimit(3)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
