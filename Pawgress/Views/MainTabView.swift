import SwiftUI

struct MainTabView: View {
    @StateObject private var authService = AuthenticationService()
    @State private var selectedTab = 0
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(AppColors.background)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HabitTrackerView()
                .environmentObject(authService)
                .tabItem {
                    Label("Habits", systemImage: "list.bullet.clipboard")
                }
                .tag(0)
            
            PetView()
                .environmentObject(authService)
                .tabItem {
                    Label("Pet", systemImage: "pawprint.fill")
                }
                .tag(1)
            
            CommunityView()
                .environmentObject(authService)
                .tabItem {
                    Label("Community", systemImage: "person.2.fill")
                }
                .tag(2)
            
            ProfileView()
                .environmentObject(authService)
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
                .tag(3)
        }
        .tint(AppColors.primary)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthenticationService())
} 