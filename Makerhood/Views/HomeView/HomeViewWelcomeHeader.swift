//
//  WelcomeHeader.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI

struct WelcomeHeader: View {
    let user: User?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greetingText)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(subtitleText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Computed Properties
    
    private var greetingText: String {
        guard let user = user else {
            return "👋 Hey there"
        }
        
        if user.role == "organization" {
            // Show organization name for organization accounts
            return "👋 Hey \(user.organizationName ?? "there")"
        } else {
            // Show first name for regular users
            let firstName = user.fullName.components(separatedBy: " ").first ?? "there"
            return "👋 Hey \(firstName)"
        }
    }
    
    private var subtitleText: String {
        guard let user = user else {
            return "Find your Makerspace"
        }
        
        if user.role == "organization" {
            return "Manage your Makerspace"
        } else {
            return "Find your Makerspace"
        }
    }
}

// MARK: - Previews

#Preview("Regular User") {
    WelcomeHeader(user: User(
        id: "1",
        email: "john@example.com",
        fullName: "John Doe",
        phoneNumber: "123456789",
        role: "user",
        createdAt: Date()
    ))
}
#Preview("Organization") {
    WelcomeHeader(user: User(
        id: "2",
        email: "contact@mitmaker.com",
        fullName: "Admin Name",
        phoneNumber: "123456789",
        role: "organization",
        createdAt: Date(),
        organizationName: "MIT Makerspace"
    ))
}

#Preview("No User") {
    WelcomeHeader(user: nil)
}

