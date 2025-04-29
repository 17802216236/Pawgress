import Foundation
import SwiftUI

class AuthenticationService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    func signIn(email: String, password: String) async throws {
        // TODO: Implement actual authentication logic
        // For now, we'll simulate a successful login
        DispatchQueue.main.async {
            self.currentUser = User(id: UUID().uuidString, email: email, username: email)
            self.isAuthenticated = true
        }
    }
    
    func signUp(email: String, password: String, username: String) async throws {
        // TODO: Implement actual registration logic
        // For now, we'll simulate a successful registration
        DispatchQueue.main.async {
            self.currentUser = User(id: UUID().uuidString, email: email, username: username)
            self.isAuthenticated = true
        }
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
    }
} 