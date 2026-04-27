//
//  PostCard.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct PostCard: View {
    let post: Post
    let onLike: () -> Void
    let onComment: () -> Void
    let onShare: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            PostCardHeader(post: post)
            PostCardContent(post: post)
            PostCardActions(
                post: post,
                onLike: onLike,
                onComment: onComment,
                onShare: onShare
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }
}

// MARK: - Post Card Header

private struct PostCardHeader: View {
    let post: Post
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            UserAvatar(name: post.userName, size: 44)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(post.userName)
                        .font(.headline)
                    
                    if let makerspaceName = post.makerspaceName {
                        Text("·")
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.caption)
                            Text(makerspaceName)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.makerYellow)
                    }
                }
                
                Text(post.createdAt.timeAgoDisplay())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Rating badge (if review)
            if let rating = post.rating {
                RatingBadge(rating: rating)
            }
        }
    }
}

// MARK: - Post Card Content

private struct PostCardContent: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(post.content)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            
            // Image placeholder (if needed)
            if !post.imageURLs.isEmpty {
                PostImageGallery(imageURLs: post.imageURLs)
            }
        }
    }
}

// MARK: - Post Card Actions

private struct PostCardActions: View {
    let post: Post
    let onLike: () -> Void
    let onComment: () -> Void
    let onShare: () -> Void
    
    var body: some View {
        HStack(spacing: 24) {
            ActionButton(
                icon: post.isLikedByCurrentUser ? "heart.fill" : "heart",
                count: post.likeCount,
                color: post.isLikedByCurrentUser ? .red : .primary,
                action: onLike
            )
            
            ActionButton(
                icon: "bubble.right",
                count: post.commentCount,
                color: .primary,
                action: onComment
            )
            
            ActionButton(
                icon: "arrowshape.turn.up.right",
                count: post.shareCount,
                color: .primary,
                action: onShare
            )
            
            Spacer()
        }
        .padding(.top, 4)
    }
}

// MARK: - Supporting Components

struct UserAvatar: View {
    let name: String
    let size: CGFloat
    
    var body: some View {
        Circle()
            .fill(Color.makerYellow.opacity(0.3))
            .frame(width: size, height: size)
            .overlay(
                Text(name.prefix(1))
                    .font(size > 40 ? .headline : .subheadline)
                    .foregroundStyle(.makerYellow)
            )
    }
}

struct RatingBadge: View {
    let rating: Double
    
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "star.fill")
                .font(.caption)
            Text(String(format: "%.1f", rating))
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

struct PostImageGallery: View {
    let imageURLs: [String]
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemGray6))
            .frame(height: 200)
            .overlay(
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            )
    }
}

struct ActionButton: View {
    let icon: String
    let count: Int
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.body)
                
                if count > 0 {
                    Text("\(count)")
                        .font(.subheadline)
                }
            }
            .foregroundStyle(color)
        }
    }
}

// MARK: - Preview

#Preview {
    PostCard(
        post: Post.sample,
        onLike: {},
        onComment: {},
        onShare: {}
    )
}
