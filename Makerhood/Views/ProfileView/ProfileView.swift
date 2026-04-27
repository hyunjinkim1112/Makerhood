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
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showEditProfile = false
    @State private var showCertificateDetail: Certification?
    
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
                    
                    // Skills & Interests
                    if let user = authViewModel.currentUser,
                       let skills = user.skills, !skills.isEmpty {
                        skillsSection(skills: skills)
                    }
                    
                    // Badges Section
                    if !viewModel.badges.isEmpty {
                        badgesSection
                    }
                    
                    // Certifications Section
                    certificationsSection
                    
                    // Equipment Usage Stats
                    equipmentStatsSection
                    
                    // My Projects (placeholder for now)
                    myProjectsSection
                    
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
            .sheet(item: $showCertificateDetail) { certificate in
                CertificateDetailView(certificate: certificate)
            }
        }
        .task {
            await viewModel.loadUserData()
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
                    value: "\(viewModel.certifications.count)",
                    label: "Certificates",
                    icon: "rosette"
                )
                
                StatItem(
                    value: "\(viewModel.totalEquipmentUses)",
                    label: "Uses",
                    icon: "hammer.fill"
                )
                
                StatItem(
                    value: "\(Int(viewModel.totalHours))",
                    label: "Hours",
                    icon: "clock.fill"
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
    
    // MARK: - Skills Section
    
    private func skillsSection(skills: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Skills")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(skills, id: \.self) { skill in
                        Text(skill)
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.makerYellow.opacity(0.2))
                            .foregroundStyle(.makerYellow)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Badges Section
    
    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "award.fill")
                    .foregroundStyle(.makerYellow)
                Text("Badges")
                    .font(.headline)
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(viewModel.badges) { badge in
                    BadgeCard(badge: badge)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Certifications Section
    
    private var certificationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "rosette")
                    .foregroundStyle(.makerYellow)
                Text("Certifications")
                    .font(.headline)
                
                Spacer()
                
                Button("View All") {
                    // Navigate to all certifications
                }
                .font(.subheadline)
                .foregroundStyle(.makerYellow)
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(viewModel.certifications.prefix(3)) { cert in
                    CertificationCard(certification: cert) {
                        showCertificateDetail = cert
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Equipment Stats Section
    
    private var equipmentStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(.makerYellow)
                Text("Equipment Usage")
                    .font(.headline)
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(viewModel.equipmentStats, id: \.equipmentType.rawValue) { stat in
                    EquipmentStatRow(stat: stat)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Projects Section
    
    private var myProjectsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "folder.fill")
                    .foregroundStyle(.makerYellow)
                Text("My Projects")
                    .font(.headline)
                
                Spacer()
                
                Button("Add New") {
                    // Add project
                }
                .font(.subheadline)
                .foregroundStyle(.makerYellow)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<3) { _ in
                        ProjectCard()
                    }
                }
                .padding(.horizontal)
            }
        }
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

// MARK: - Badge Card

struct BadgeCard: View {
    let badge: Badge
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.makerYellow.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: badge.badgeType.iconName)
                    .font(.title2)
                    .foregroundStyle(.makerYellow)
            }
            
            Text(badge.badgeType.rawValue)
                .font(.caption2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Certification Card

struct CertificationCard: View {
    let certification: Certification
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Equipment Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.makerYellow.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: certification.equipmentType.iconName)
                        .font(.title3)
                        .foregroundStyle(.makerYellow)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(certification.equipmentType.rawValue)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text(certification.makerspaceName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 6) {
                        // Level Badge
                        Text(certification.level.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(levelColor(certification.level).opacity(0.2))
                            .foregroundStyle(levelColor(certification.level))
                            .cornerRadius(6)
                        
                        // Valid Badge
                        if certification.isValid {
                            HStack(spacing: 3) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.caption2)
                                Text("Valid")
                                    .font(.caption2)
                            }
                            .foregroundStyle(.green)
                        } else {
                            HStack(spacing: 3) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.caption2)
                                Text("Expired")
                                    .font(.caption2)
                            }
                            .foregroundStyle(.red)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
    
    private func levelColor(_ level: CertificationLevel) -> Color {
        switch level {
        case .beginner: return .green
        case .intermediate: return .blue
        case .advanced: return .purple
        case .instructor: return .orange
        }
    }
}

// MARK: - Equipment Stat Row

struct EquipmentStatRow: View {
    let stat: EquipmentStats
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: stat.equipmentType.iconName)
                .font(.title3)
                .foregroundStyle(.makerYellow)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(stat.equipmentType.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    if stat.hasCertification {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }
                
                Text("\(stat.totalUses) uses · \(String(format: "%.1f", stat.totalHours)) hours")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if let level = stat.certificationLevel {
                Text(level.rawValue)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.makerYellow.opacity(0.2))
                    .foregroundStyle(.makerYellow)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
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

// MARK: - Certificate Detail View

struct CertificateDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let certificate: Certification
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Certificate Badge
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.makerYellow.opacity(0.6), Color.makerYellow.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 150, height: 150)
                        
                        VStack(spacing: 8) {
                            Image(systemName: certificate.equipmentType.iconName)
                                .font(.system(size: 50))
                                .foregroundStyle(.white)
                            
                            Image(systemName: "rosette")
                                .font(.title)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    .shadow(color: Color.makerYellow.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    // Certificate Info
                    VStack(spacing: 16) {
                        Text(certificate.equipmentType.rawValue)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(certificate.level.rawValue + " Level")
                            .font(.title3)
                            .foregroundStyle(.makerYellow)
                        
                        Divider()
                            .padding(.horizontal, 40)
                        
                        // Details
                        VStack(spacing: 12) {
                            DetailRow(
                                icon: "building.2.fill",
                                label: "Makerspace",
                                value: certificate.makerspaceName
                            )
                            
                            DetailRow(
                                icon: "person.fill",
                                label: "Instructor",
                                value: certificate.instructorName
                            )
                            
                            DetailRow(
                                icon: "calendar",
                                label: "Certified Date",
                                value: certificate.certifiedAt.formatted(date: .long, time: .omitted)
                            )
                            
                            if let expiresAt = certificate.expiresAt {
                                DetailRow(
                                    icon: "calendar.badge.clock",
                                    label: "Expires",
                                    value: expiresAt.formatted(date: .long, time: .omitted)
                                )
                            } else {
                                DetailRow(
                                    icon: "infinity",
                                    label: "Validity",
                                    value: "Never Expires"
                                )
                            }
                            
                            DetailRow(
                                icon: "number",
                                label: "Certificate #",
                                value: certificate.certificateNumber
                            )
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding()
                    
                    // Verification Status
                    HStack(spacing: 12) {
                        Image(systemName: certificate.isValid ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                            .font(.title2)
                            .foregroundStyle(certificate.isValid ? .green : .orange)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(certificate.isValid ? "Valid Certificate" : "Certificate Expired")
                                .font(.headline)
                                .foregroundStyle(certificate.isValid ? .green : .orange)
                            
                            Text(certificate.isValid ? "Accepted at all Makerhood spaces" : "Please renew your certification")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(certificate.isValid ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Certificate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Label(label, systemImage: icon)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 120, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
        }
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
                
                Section("Skills") {
                    ForEach(skills, id: \.self) { skill in
                        Text(skill)
                    }
                    .onDelete { indexSet in
                        skills.remove(atOffsets: indexSet)
                    }
                    
                    HStack {
                        TextField("Add skill", text: $newSkill)
                        Button("Add") {
                            if !newSkill.isEmpty {
                                skills.append(newSkill)
                                newSkill = ""
                            }
                        }
                        .disabled(newSkill.isEmpty)
                    }
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

// MARK: - Profile View Model

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var certifications: [Certification] = []
    @Published var equipmentUsages: [EquipmentUsage] = []
    @Published var badges: [Badge] = []
    @Published var equipmentStats: [EquipmentStats] = []
    @Published var isLoading = false
    
    var totalEquipmentUses: Int {
        equipmentUsages.count
    }
    
    var totalHours: Double {
        Double(equipmentUsages.reduce(0) { $0 + $1.durationMinutes }) / 60.0
    }
    
    func loadUserData() async {
        isLoading = true
        
        // Load from Firebase in production
        // For now, use sample data
        certifications = Certification.samples
        equipmentUsages = EquipmentUsage.samples
        badges = Badge.samples
        
        calculateEquipmentStats()
        
        isLoading = false
    }
    
    private func calculateEquipmentStats() {
        var statsDict: [EquipmentType: EquipmentStats] = [:]
        
        for usage in equipmentUsages {
            if var stat = statsDict[usage.equipmentType] {
                stat = EquipmentStats(
                    equipmentType: stat.equipmentType,
                    totalUses: stat.totalUses + 1,
                    totalHours: stat.totalHours + Double(usage.durationMinutes) / 60.0,
                    lastUsed: max(stat.lastUsed ?? usage.usedAt, usage.usedAt),
                    hasCertification: stat.hasCertification,
                    certificationLevel: stat.certificationLevel
                )
                statsDict[usage.equipmentType] = stat
            } else {
                let cert = certifications.first { $0.equipmentType == usage.equipmentType }
                statsDict[usage.equipmentType] = EquipmentStats(
                    equipmentType: usage.equipmentType,
                    totalUses: 1,
                    totalHours: Double(usage.durationMinutes) / 60.0,
                    lastUsed: usage.usedAt,
                    hasCertification: cert != nil,
                    certificationLevel: cert?.level
                )
            }
        }
        
        equipmentStats = statsDict.values.sorted { $0.totalUses > $1.totalUses }
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
