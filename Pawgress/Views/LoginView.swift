import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var authService = AuthenticationService()
    @State private var isShowingSignUp = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Frog mascot and welcome text
                    VStack(spacing: 20) {
                        Image("frog_mascot") // Make sure to add this image to assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        
                        Text("Welcome!")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppColors.primary)
                    }
                    
                    // Login options
                    VStack(spacing: 16) {
                        Text("Log in")
                            .font(.title2)
                            .foregroundColor(AppColors.primary)
                        
                        // Google Sign In
                        Button(action: { /* TODO: Implement Google Sign In */ }) {
                            HStack {
                                Image("google_icon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Continue with Google")
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 2)
                        }
                        
                        // Apple Sign In
                        SignInWithAppleButton { request in
                            request.requestedScopes = [.email, .fullName]
                        } onCompletion: { result in
                            // Handle sign in with Apple result
                        }
                        .frame(height: 50)
                        .cornerRadius(12)
                        
                        // Email Sign In
                        Button(action: { isShowingSignUp = true }) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                Text("Continue with Email")
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 2)
                        }
                        
                        // Phone Sign In
                        Button(action: { /* TODO: Implement Phone Sign In */ }) {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("Continue with Cell Phone")
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 2)
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("Already have accounts?")
                        .foregroundColor(AppColors.primary)
                        .underline()
                }
                .padding()
            }
            .sheet(isPresented: $isShowingSignUp) {
                EmailSignUpView(authService: authService)
            }
        }
    }
}

struct EmailSignUpView: View {
    @ObservedObject var authService: AuthenticationService
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Sign Up with Email")
                        .font(.title2)
                        .bold()
                        .foregroundColor(AppColors.primary)
                    
                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedTextFieldStyle())
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedTextFieldStyle())
                        
                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    
                    Button(action: {
                        Task {
                            do {
                                try await authService.signUp(email: email, password: password, username: email)
                                dismiss()
                            } catch {
                                errorMessage = "Error creating account"
                            }
                        }
                    }) {
                        Text("Create Account")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.secondary)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            })
        }
    }
}

struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 2)
    }
}

#Preview("Login") {
    LoginView()
        .environmentObject(AuthenticationService())
}

#Preview("Sign Up") {
    EmailSignUpView(authService: AuthenticationService())
} 
