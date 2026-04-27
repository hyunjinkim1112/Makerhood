//
//  Post.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import Foundation

struct Post: Identifiable, Codable, Hashable {
    let id: String
    let userId: String
    let userName: String
    let makerspaceId: String?
    let makerspaceName: String?
    let content: String
    let imageURLs: [String]
    let rating: Double? // If this is a review, include rating
    let createdAt: Date
    var likeCount: Int
    var commentCount: Int
    var shareCount: Int
    var isLikedByCurrentUser: Bool
    
    var isReview: Bool {
        rating != nil && makerspaceId != nil
    }
    
    // For preview/mock data
    static var sample: Post {
        Post(
            id: "1",
            userId: "user1",
            userName: "Jane Smith",
            makerspaceId: "1",
            makerspaceName: "BC Fab Lab",
            content: "Finished my PCB! 🎉 The equipment here is top-notch and the staff was super helpful!",
            imageURLs: [],
            rating: 4.5,
            createdAt: Date().addingTimeInterval(-3600),
            likeCount: 24,
            commentCount: 6,
            shareCount: 2,
            isLikedByCurrentUser: false
        )
    }
    
    static var samples: [Post] {
        [
            Post(
                id: "1",
                userId: "user1",
                userName: "Jane Smith",
                makerspaceId: "2",
                makerspaceName: "BC Fab Lab",
                content: "Finished my PCB! 🎉 The equipment here is top-notch and the staff was super helpful!",
                imageURLs: [],
                rating: 4.5,
                createdAt: Date().addingTimeInterval(-3600),
                likeCount: 24,
                commentCount: 6,
                shareCount: 2,
                isLikedByCurrentUser: false
            ),
            Post(
                id: "2",
                userId: "user2",
                userName: "Mike Johnson",
                makerspaceId: "1",
                makerspaceName: "MIT Makerspace",
                content: "3D printing some custom parts for my robotics project. Love the Prusa i3 MK3S+ they have here!",
                imageURLs: [],
                rating: 5.0,
                createdAt: Date().addingTimeInterval(-7200),
                likeCount: 42,
                commentCount: 12,
                shareCount: 5,
                isLikedByCurrentUser: true
            ),
            Post(
                id: "3",
                userId: "user3",
                userName: "Sarah Chen",
                makerspaceId: nil,
                makerspaceName: nil,
                content: "Anyone know where I can find a good laser cutter in Boston? Looking to cut some acrylic sheets.",
                imageURLs: [],
                rating: nil,
                createdAt: Date().addingTimeInterval(-10800),
                likeCount: 8,
                commentCount: 15,
                shareCount: 0,
                isLikedByCurrentUser: false
            ),
            Post(
                id: "4",
                userId: "user4",
                userName: "Alex Rivera",
                makerspaceId: "4",
                makerspaceName: "TechHub Makerspace",
                content: "Just finished my woodworking project! The CNC router made everything so much easier. Highly recommend this space!",
                imageURLs: [],
                rating: 4.8,
                createdAt: Date().addingTimeInterval(-14400),
                likeCount: 56,
                commentCount: 9,
                shareCount: 8,
                isLikedByCurrentUser: true
            ),
            Post(
                id: "5",
                userId: "user5",
                userName: "Emily Davis",
                makerspaceId: "3",
                makerspaceName: "South End Studio",
                content: "Screen printing session today! The staff taught me some great techniques. Super friendly environment 🎨",
                imageURLs: [],
                rating: 4.3,
                createdAt: Date().addingTimeInterval(-18000),
                likeCount: 31,
                commentCount: 7,
                shareCount: 3,
                isLikedByCurrentUser: false
            ),
            Post(
                id: "6",
                userId: "user1",
                userName: "Jane Smith",
                makerspaceId: nil,
                makerspaceName: nil,
                content: "Sharing some tips for beginners: Always wear safety glasses when using power tools! 🥽",
                imageURLs: [],
                rating: nil,
                createdAt: Date().addingTimeInterval(-21600),
                likeCount: 92,
                commentCount: 18,
                shareCount: 24,
                isLikedByCurrentUser: true
            )
        ]
    }
}

struct Comment: Identifiable, Codable, Hashable {
    let id: String
    let postId: String
    let userId: String
    let userName: String
    let content: String
    let createdAt: Date
    var likeCount: Int
    var isLikedByCurrentUser: Bool
    
    static var sample: Comment {
        Comment(
            id: "1",
            postId: "1",
            userId: "user2",
            userName: "Mike Johnson",
            content: "Looks amazing! Great work!",
            createdAt: Date().addingTimeInterval(-1800),
            likeCount: 3,
            isLikedByCurrentUser: false
        )
    }
    
    static var samples: [Comment] {
        [
            Comment(
                id: "1",
                postId: "1",
                userId: "user2",
                userName: "Mike Johnson",
                content: "Looks amazing! Great work!",
                createdAt: Date().addingTimeInterval(-1800),
                likeCount: 3,
                isLikedByCurrentUser: false
            ),
            Comment(
                id: "2",
                postId: "1",
                userId: "user3",
                userName: "Sarah Chen",
                content: "I've been wanting to try PCB fabrication. How was your experience?",
                createdAt: Date().addingTimeInterval(-1500),
                likeCount: 1,
                isLikedByCurrentUser: true
            ),
            Comment(
                id: "3",
                postId: "1",
                userId: "user1",
                userName: "Jane Smith",
                content: "It was great! The staff really helped me understand the process.",
                createdAt: Date().addingTimeInterval(-1200),
                likeCount: 2,
                isLikedByCurrentUser: false
            )
        ]
    }
}

extension Post {
    static func fromDictionary(_ dict: [String: Any], id: String) -> Post? {
        guard let userId = dict["userId"] as? String,
              let userName = dict["userName"] as? String,
              let content = dict["content"] as? String,
              let imageURLs = dict["imageURLs"] as? [String],
              let likeCount = dict["likeCount"] as? Int,
              let commentCount = dict["commentCount"] as? Int,
              let shareCount = dict["shareCount"] as? Int else {
            return nil
        }
        
        let createdAt: Date = {
            if let timestamp = dict["createdAt"] as? Double {
                return Date(timeIntervalSince1970: timestamp)
            }
            return Date()
        }()
        
        return Post(
            id: id,
            userId: userId,
            userName: userName,
            makerspaceId: dict["makerspaceId"] as? String,
            makerspaceName: dict["makerspaceName"] as? String,
            content: content,
            imageURLs: imageURLs,
            rating: dict["rating"] as? Double,
            createdAt: createdAt,
            likeCount: likeCount,
            commentCount: commentCount,
            shareCount: shareCount,
            isLikedByCurrentUser: false // Will be determined by checking likes collection
        )
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "userId": userId,
            "userName": userName,
            "content": content,
            "imageURLs": imageURLs,
            "createdAt": createdAt.timeIntervalSince1970,
            "likeCount": likeCount,
            "commentCount": commentCount,
            "shareCount": shareCount
        ]
        
        if let makerspaceId = makerspaceId {
            dict["makerspaceId"] = makerspaceId
        }
        if let makerspaceName = makerspaceName {
            dict["makerspaceName"] = makerspaceName
        }
        if let rating = rating {
            dict["rating"] = rating
        }
        
        return dict
    }
}

extension Comment {
    static func fromDictionary(_ dict: [String: Any], id: String) -> Comment? {
        guard let postId = dict["postId"] as? String,
              let userId = dict["userId"] as? String,
              let userName = dict["userName"] as? String,
              let content = dict["content"] as? String,
              let likeCount = dict["likeCount"] as? Int else {
            return nil
        }
        
        let createdAt: Date = {
            if let timestamp = dict["createdAt"] as? Double {
                return Date(timeIntervalSince1970: timestamp)
            }
            return Date()
        }()
        
        return Comment(
            id: id,
            postId: postId,
            userId: userId,
            userName: userName,
            content: content,
            createdAt: createdAt,
            likeCount: likeCount,
            isLikedByCurrentUser: false
        )
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "postId": postId,
            "userId": userId,
            "userName": userName,
            "content": content,
            "createdAt": createdAt.timeIntervalSince1970,
            "likeCount": likeCount
        ]
    }
}
