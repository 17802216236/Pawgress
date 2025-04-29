import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthenticationService
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        VStack(spacing: 16) {
                            Image("frog_mascot")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(AppColors.accent, lineWidth: 2))
                            
                            VStack(spacing: 4) {
                                Text(authService.currentUser?.username ?? "User")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(AppColors.primary)
                                
                                Text(authService.currentUser?.email ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(AppColors.primary.opacity(0.8))
                            }
                        }
                        .padding()
                        
                        // Statistics
                        VStack(spacing: 16) {
                            Text("Your Progress")
                                .font(.headline)
                                .foregroundColor(AppColors.primary)
                            
                            HStack(spacing: 20) {
                                StatCard(title: "Streak", value: "\(authService.currentUser?.streakCount ?? 0)", icon: "flame.fill")
                                StatCard(title: "Tasks", value: "0", icon: "checkmark.circle.fill")
                                StatCard(title: "Postcards", value: "0", icon: "envelope.fill")
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        
                        // Settings
                        VStack(spacing: 16) {
                            Text("Settings")
                                .font(.headline)
                                .foregroundColor(AppColors.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 0) {
                                SettingsRow(title: "Edit Profile", icon: "person.fill") {
                                    showingEditProfile = true
                                }
                                
                                SettingsRow(title: "Notifications", icon: "bell.fill") {
                                    // TODO: Implement notifications settings
                                }
                                
                                SettingsRow(title: "Privacy", icon: "lock.fill") {
                                    // TODO: Implement privacy settings
                                }
                                
                                SettingsRow(title: "Help & Support", icon: "questionmark.circle.fill") {
                                    // TODO: Implement help & support
                                }
                                
                                SettingsRow(title: "Sign Out", icon: "arrow.right.square.fill", showDivider: false) {
                                    authService.signOut()
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                        }
                        .padding()
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(AppColors.accent)
            
            Text(value)
                .font(.title3)
                .bold()
                .foregroundColor(AppColors.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(AppColors.primary.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    var showDivider: Bool = true
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(AppColors.accent)
                        .frame(width: 24)
                    
                    Text(title)
                        .foregroundColor(AppColors.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.primary.opacity(0.5))
                }
                .padding()
            }
            
            if showDivider {
                Divider()
                    .padding(.horizontal)
            }
        }
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthenticationService
    @State private var username: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image("frog_mascot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(AppColors.accent, lineWidth: 2))
                    
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedTextFieldStyle())
                        .padding()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // TODO: Implement save profile changes
                        dismiss()
                    }
                }
            }
            .onAppear {
                username = authService.currentUser?.username ?? ""
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationService())
} 