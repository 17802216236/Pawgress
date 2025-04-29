//
//  PawgressApp.swift
//  Pawgress
//
//  Created by Emily on 2025/4/16.
//

import SwiftUI

@main
struct PawgressApp: App {
    @StateObject private var authService = AuthenticationService()
    
    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated {
                MainTabView()
                    .environmentObject(authService)
            } else {
                LoginView()
                    .environmentObject(authService)
            }
        }
    }
}
