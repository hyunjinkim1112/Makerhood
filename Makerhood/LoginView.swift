//
//  LoginView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var selectedRole: UserRole?
    @State private var showSignUp = false
    @State private var showRoleSelection = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                // Logo or App Name
                VStack(spacing: 8) {
                    Image(systemName: "hammer.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(Color.makerYellow)
                    
                    Text("Makerhood")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                // Login Form
                VStack(spacing: 20) {
                    // Email Field
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
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        HStack {
                            if showPassword {
                                TextField("Enter your password", text: $password)
                                    .textContentType(.password)
                                    .autocapitalization(.none)
                            } else {
                                SecureField("Enter your password", text: $password)
                                    .textContentType(.password)
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
                    
                    // Forgot Password
                    HStack {
                        Spacer()
                        Button("Forgot Password?") {
                            // Handle forgot password
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color.makerYellow)
                    }
                }
                .padding(.horizontal, 30)
                
                // Login Button
                Button(action: {
                    // Handle login
                }) {
                    Text("Log In")
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.makerYellow)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .disabled(email.isEmpty || password.isEmpty)
                .opacity(email.isEmpty || password.isEmpty ? 0.5 : 1.0)
                
                Spacer()
                
                // Sign Up Link
                HStack {
                    Text("Don't have an account?")
                        .foregroundStyle(.secondary)
                    Button("Sign Up") {
                        showRoleSelection = true
                    }
                    .fontWeight(.semibold)
                }
                .padding(.bottom, 30)
            }
            .background(Color.makerYellow.opacity(0.1))
            .sheet(isPresented: $showRoleSelection) {
                RoleSelectionView(selectedRole: $selectedRole, showSignUp: $showSignUp)
            }
            .sheet(isPresented: $showSignUp) {
                if selectedRole == .user {
                    UserSignUpView()
                } else if selectedRole == .organization {
                    OrganizationSignUpView()
                }
            }
            .onChange(of: showSignUp) { oldValue, newValue in
                if !newValue {
                    // Reset role selection when signup sheet is dismissed
                    selectedRole = nil
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
