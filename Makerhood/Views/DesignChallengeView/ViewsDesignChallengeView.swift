//
//  DesignChallengeView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 23/4/26.
//

import SwiftUI

struct DesignChallengeView: View {
    @StateObject private var viewModel = DesignChallengeViewModel()
    @State private var showFilters = false
    @State private var showSavedChallenges = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.makerYellow.opacity(0.1),
                        Color.makerYellow.opacity(0.05),
                        Color(.systemBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerSection
                        
                        // AI Status Banner (if unavailable)
                        if !viewModel.isAIAvailable {
                            aiStatusBanner
                        }
                        
                        // Challenge Card
                        if let challenge = viewModel.currentChallenge {
                            challengeCard(challenge)
                                .transition(.asymmetric(
                                    insertion: .scale.combined(with: .opacity),
                                    removal: .opacity
                                ))
                        } else {
                            placeholderCard
                        }
                        
                        // Action Buttons
                        actionButtons
                        
                        // Filter Section
                        if showFilters {
                            filterSection
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding()
                }
            }
            .navigationTitle("Design Challenge")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showSavedChallenges = true
                    }) {
                        Image(systemName: "bookmark.fill")
                            .foregroundStyle(.makerYellow)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            showFilters.toggle()
                        }
                    }) {
                        Image(systemName: showFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                            .foregroundStyle(.makerYellow)
                    }
                }
            }
            .sheet(isPresented: $showSavedChallenges) {
                SavedChallengesView(viewModel: viewModel)
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.makerYellow, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("Get Inspired")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Generate unique design challenges\nto spark your creativity")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 8)
    }
    
    // MARK: - AI Status Banner
    
    private var aiStatusBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Using Curated Challenges")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                if let reason = viewModel.aiUnavailabilityReason {
                    Text(reason)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Challenge Card
    
    private func challengeCard(_ challenge: DesignChallenge) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // Category and Difficulty badges
            HStack {
                // Category badge
                HStack(spacing: 6) {
                    Image(systemName: challenge.category.icon)
                        .font(.caption)
                    Text(challenge.category.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.makerYellow)
                .cornerRadius(8)
                
                // Difficulty badge
                HStack(spacing: 4) {
                    Text(challenge.difficulty.emoji)
                        .font(.caption)
                    Text(challenge.difficulty.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                Spacer()
                
                // AI Generated indicator
                if challenge.isAIGenerated {
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundStyle(.purple)
                }
            }
            
            // Title
            Text(challenge.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Divider()
            
            // Description
            VStack(alignment: .leading, spacing: 12) {
                Label("Challenge", systemImage: "target")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.makerYellow)
                
                Text(challenge.description)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Divider()
            
            // Constraint
            VStack(alignment: .leading, spacing: 12) {
                Label("Constraint", systemImage: "slider.horizontal.3")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.makerYellow)
                
                Text(challenge.constraint)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Save button
            HStack {
                Spacer()
                
                Button(action: {
                    if viewModel.isCurrentChallengeSaved() {
                        viewModel.removeSavedChallenge(challenge)
                    } else {
                        viewModel.saveCurrentChallenge()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: viewModel.isCurrentChallengeSaved() ? "bookmark.fill" : "bookmark")
                        Text(viewModel.isCurrentChallengeSaved() ? "Saved" : "Save Challenge")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(viewModel.isCurrentChallengeSaved() ? .makerYellow : .secondary)
                }
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Placeholder Card
    
    private var placeholderCard: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading your challenge...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(height: 400)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            // Generate New Button
            Button(action: {
                Task {
                    withAnimation(.spring(response: 0.3)) {
                        await viewModel.generateNewChallenge()
                    }
                }
            }) {
                HStack {
                    if viewModel.isGenerating {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    } else {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                    
                    Text(viewModel.isGenerating ? "Generating..." : "Generate New Challenge")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.makerYellow)
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
            .disabled(viewModel.isGenerating)
            
            // Share Button
            if let challenge = viewModel.currentChallenge {
                ShareLink(
                    item: shareText(for: challenge),
                    subject: Text(challenge.title),
                    message: Text("Check out this design challenge!")
                ) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share Challenge")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .foregroundStyle(.primary)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    // MARK: - Filter Section
    
    private var filterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Filters")
                    .font(.headline)
                
                Spacer()
                
                if viewModel.selectedDifficulty != nil || viewModel.selectedCategory != nil {
                    Button("Clear All") {
                        withAnimation {
                            viewModel.clearFilters()
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.makerYellow)
                }
            }
            
            // Difficulty Filter
            VStack(alignment: .leading, spacing: 8) {
                Text("Difficulty")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(DesignChallenge.Difficulty.allCases, id: \.self) { difficulty in
                            Button(action: {
                                withAnimation {
                                    viewModel.selectedDifficulty = viewModel.selectedDifficulty == difficulty ? nil : difficulty
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Text(difficulty.emoji)
                                    Text(difficulty.rawValue)
                                }
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(viewModel.selectedDifficulty == difficulty ? .white : .primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(viewModel.selectedDifficulty == difficulty ? Color.makerYellow : Color(.systemGray6))
                                .cornerRadius(20)
                            }
                        }
                    }
                }
            }
            
            // Category Filter
            VStack(alignment: .leading, spacing: 8) {
                Text("Category")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(DesignChallenge.Category.allCases, id: \.self) { category in
                            Button(action: {
                                withAnimation {
                                    viewModel.selectedCategory = viewModel.selectedCategory == category ? nil : category
                                }
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: category.icon)
                                        .font(.caption)
                                    Text(category.rawValue)
                                }
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(viewModel.selectedCategory == category ? .white : .primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(viewModel.selectedCategory == category ? Color.makerYellow : Color(.systemGray6))
                                .cornerRadius(20)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(12)
    }
    
    // MARK: - Helpers
    
    private func shareText(for challenge: DesignChallenge) -> String {
        """
        🎨 Design Challenge: \(challenge.title)
        
        \(challenge.description)
        
        Constraint: \(challenge.constraint)
        
        Difficulty: \(challenge.difficulty.rawValue)
        Category: \(challenge.category.rawValue)
        
        #Makerhood #DesignChallenge
        """
    }
}

// MARK: - Saved Challenges View

struct SavedChallengesView: View {
    @ObservedObject var viewModel: DesignChallengeViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.savedChallenges.isEmpty {
                    emptyState
                } else {
                    challengesList
                }
            }
            .navigationTitle("Saved Challenges")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.makerYellow)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bookmark.slash")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No Saved Challenges")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Save challenges you want to try later")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxHeight: .infinity)
    }
    
    private var challengesList: some View {
        List {
            ForEach(viewModel.savedChallenges) { challenge in
                SavedChallengeRow(challenge: challenge)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.removeSavedChallenge(challenge)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
    }
}

// MARK: - Saved Challenge Row

struct SavedChallengeRow: View {
    let challenge: DesignChallenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Badges
            HStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: challenge.category.icon)
                        .font(.caption2)
                    Text(challenge.category.rawValue)
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.makerYellow)
                .cornerRadius(6)
                
                HStack(spacing: 2) {
                    Text(challenge.difficulty.emoji)
                        .font(.caption2)
                    Text(challenge.difficulty.rawValue)
                        .font(.caption2)
                }
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.systemGray6))
                .cornerRadius(6)
            }
            
            // Title
            Text(challenge.title)
                .font(.headline)
            
            // Description
            Text(challenge.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview("Design Challenge View") {
    DesignChallengeView()
}

#Preview("Saved Challenges - Empty") {
    SavedChallengesView(viewModel: DesignChallengeViewModel())
}
