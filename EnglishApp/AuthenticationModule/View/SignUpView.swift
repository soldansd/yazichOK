//
//  SignUpView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SignUpViewModel()
    @FocusState private var focusedField: Field?

    enum Field {
        case fullName, email, password
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Illustration placeholder
                    Image(systemName: "person.3.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .foregroundStyle(.blue.opacity(0.3))
                        .padding(.top, 40)

                    // Title
                    VStack(spacing: 8) {
                        Text("Start Learning English")
                            .font(.title)
                            .bold()

                        Text("Join millions of students worldwide")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                        .frame(height: 20)

                    // Full Name field
                    TextField("Full Name", text: $viewModel.fullName)
                        .textFieldStyle(.plain)
                        .textContentType(.name)
                        .autocapitalization(.words)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .focused($focusedField, equals: .fullName)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .email
                        }

                    // Email field
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(.plain)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }

                    // Password field
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(.plain)
                        .textContentType(.newPassword)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .focused($focusedField, equals: .password)
                        .submitLabel(.go)
                        .onSubmit {
                            Task {
                                await viewModel.signUp()
                            }
                        }

                    // Confirm Password field (not in screenshot but mentioned in plan)
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .textFieldStyle(.plain)
                        .textContentType(.newPassword)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .submitLabel(.go)
                        .onSubmit {
                            Task {
                                await viewModel.signUp()
                            }
                        }

                    // Error message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                    }

                    // Create Account button
                    Button {
                        Task {
                            await viewModel.signUp()
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Create Account")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(viewModel.isValid ? Color.blue : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(!viewModel.isValid || viewModel.isLoading)

                    // Privacy policy text
                    HStack(spacing: 4) {
                        Text("By signing up, you agree to our")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("Privacy Policy")
                            .font(.caption)
                            .foregroundStyle(.blue)
                        Text("Terms and")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    // Sign in link
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundStyle(.secondary)
                        Button {
                            dismiss()
                        } label: {
                            Text("Log in")
                                .bold()
                                .foregroundStyle(.blue)
                        }
                    }
                    .font(.subheadline)

                    Spacer()
                }
                .padding(.horizontal, 32)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.primary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
