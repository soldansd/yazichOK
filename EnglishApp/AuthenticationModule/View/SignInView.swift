//
//  SignInView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Spacer()
                            .frame(height: 60)

                        // Icon
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.gray.opacity(0.6))

                        // Title
                        Text("Welcome back")
                            .font(.title)
                            .bold()

                        // Subtitle
                        Text("Sign in to continue to your account")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Spacer()
                            .frame(height: 20)

                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .foregroundStyle(.primary)

                            TextField("Enter your email", text: $viewModel.email)
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
                        }

                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .foregroundStyle(.primary)

                            SecureField("Enter your password", text: $viewModel.password)
                                .textFieldStyle(.plain)
                                .textContentType(.password)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .focused($focusedField, equals: .password)
                                .submitLabel(.go)
                                .onSubmit {
                                    Task {
                                        await viewModel.signIn()
                                    }
                                }
                        }

                        // Error message
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(.horizontal)
                        }

                        Spacer()
                            .frame(height: 20)

                        // Sign In button
                        Button {
                            Task {
                                await viewModel.signIn()
                            }
                        } label: {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Sign In")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .background(viewModel.isValid ? Color.blue : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .disabled(!viewModel.isValid || viewModel.isLoading)

                        // Sign up link
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .foregroundStyle(.secondary)
                            NavigationLink {
                                SignUpView()
                            } label: {
                                Text("Sign up")
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
        }
    }
}

#Preview {
    SignInView()
}
