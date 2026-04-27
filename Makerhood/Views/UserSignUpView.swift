//
//  UserSignUpView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import SwiftUI

struct UserSignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phoneNumber = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(Color.makerYellow)
                        
                        Text("Create User Account")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Join makerspaces and workshops")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Form Fields
                    VStack(spacing: 20) {
                        // Full Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            TextField("Enter your full name", text: $fullName)
                                .textContentType(.name)
                                .autocapitalization(.words)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                        
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            TextField("Enter your email", text: $email)
                                .textContentType(.emailAddress)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                        
                        // Phone Number
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Phone Number")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            TextField("Enter your phone number", text: $phoneNumber)
                                .textContentType(.telephoneNumber)
                                .keyboardType(.phonePad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            HStack {
                                if showPassword {
                                    TextField("Create a password", text: $password)
                                        .textContentType(.newPassword)
                                        .autocapitalization(.none)
                                } else {
                                    SecureField("Create a password", text: $password)
                                        .textContentType(.newPassword)
                                        .autocapitalization(.none)
                                }
                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            HStack {
                                if showConfirmPassword {
                                    TextField("Confirm your password", text: $confirmPassword)
                                        .textContentType(.newPassword)
                                        .autocapitalization(.none)
                                } else {
                                    SecureField("Confirm your password", text: $confirmPassword)
                                        .textContentType(.newPassword)
                                        .autocapitalization(.none)
                                }
                                Button(action: { showConfirmPassword.toggle() }) {
                                    Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                            if !confirmPassword.isEmpty && password != confirmPassword {
                                Text("Passwords do not match")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        // Error Message
                        if let errorMessage = authViewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    // Sign Up Button
                    Button(action: {
                        Task {
                            await authViewModel.signUpUser(
                                fullName: fullName,
                                email: email,
                                password: password,
                                phoneNumber: phoneNumber
                            )
                            
                            if authViewModel.isAuthenticated {
                                dismiss()
                            }
                        }
                    }) {
                        if authViewModel.isLoading {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.makerYellow)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                    .disabled(!isFormValid || authViewModel.isLoading)
                    .opacity(isFormValid && !authViewModel.isLoading ? 1.0 : 0.5)
                    
                    // Terms
                    Text("By signing up, you agree to our Terms of Service and Privacy Policy")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                .padding(.bottom, 30)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        !phoneNumber.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        password.count >= 6
    }
}

#Preview {
    UserSignUpView()
        .environmentObject(AuthViewModel())
}
