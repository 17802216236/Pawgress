import SwiftUI

struct PetView: View {
    @State private var pet = Pet(id: UUID().uuidString, name: "Frodo", species: .frog)
    @State private var showingPostcards = false
    @State private var showingChat = false
    @State private var travelOffset: CGFloat = -60
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Pet Header
                    Text("Meet Your Pet")
                        .font(.title)
                        .bold()
                        .foregroundColor(AppColors.primary)
                    
                    // Pet Avatar and Introduction
                    VStack(spacing: 16) {
                        Image("frog_mascot2")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                        
                        VStack(spacing: 8) {
                            Text("Hi, I'm \(pet.name)!")
                                .font(.title2)
                                .bold()
                                .foregroundColor(AppColors.primary)
                            
                            Text("Your cute companion")
                                .font(.subheadline)
                                .foregroundColor(AppColors.primary.opacity(0.8))
                        }
                        
                        Button(action: { showingChat = true }) {
                            Text("Chat with \(pet.name)!")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.accent)
                                .cornerRadius(25)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(20)
                    
                    // Travel Animation
                    VStack(spacing: 16) {
                        Image("planetTravel")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                        
                        HStack(spacing: 2) {
                            Text("\(pet.name) is traveling to \(pet.currentPlanet.rawValue)")
                                .font(.headline)
                                .foregroundColor(AppColors.primary)
                            
                            Text("...")
                                .font(.headline)
                                .foregroundColor(AppColors.primary)
                                .opacity(travelOffset == 60 ? 1 : 0)
                                .animation(
                                    Animation.easeInOut(duration: 1)
                                        .repeatForever(autoreverses: true),
                                    value: travelOffset
                                )
                        }
                    }
                    
                    // Postcard Button
                    Button(action: { showingPostcards = true }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .font(.title2)
                            VStack(alignment: .leading) {
                                Text("Postcard Inbox")
                                    .font(.headline)
                                Text("wish you were here!")
                                    .font(.subheadline)
                                    .foregroundColor(AppColors.primary.opacity(0.8))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .sheet(isPresented: $showingPostcards) {
                PostcardListView(pet: $pet)
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled(false)
            }
            .sheet(isPresented: $showingChat) {
                ChatView(pet: pet)
            }
            .onAppear {
                // Start travel animation
                withAnimation {
                    travelOffset = 60
                }
            }
        }
    }
}

struct PostcardListView: View {
    @Binding var pet: Pet
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Mailbox Image and Mascot
                    HStack(spacing: 0) {
                        Image("mailBox")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                        
                        Image("frog_mascot")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                    }
                    .padding(.vertical)
                    
                    // Postcards
                    ForEach(pet.unlockedPostcards) { postcard in
                        PostcardView(postcard: postcard)
                            .padding(.horizontal)
                    }
                    
                    if pet.unlockedPostcards.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "envelope.badge.fill")
                                .font(.system(size: 50))
                                .foregroundColor(AppColors.secondary)
                            
                            Text("No postcards yet!")
                                .font(.headline)
                                .foregroundColor(AppColors.primary)
                            
                            Text("Complete daily tasks to receive postcards from your pet!")
                                .font(.subheadline)
                                .foregroundColor(AppColors.primary.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Postcard Inbox")
            .navigationBarTitleDisplayMode(.inline)
            .background(AppColors.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(AppColors.primary)
                    }
                }
            }
        }
    }
}

struct PostcardView: View {
    let postcard: Postcard
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: { showingDetail = true }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(postcard.planet.rawValue)
                        .font(.headline)
                        .foregroundColor(AppColors.primary)
                    
                    Spacer()
                    
                    Text("Friday, 25 April")
                        .font(.subheadline)
                        .foregroundColor(AppColors.primary.opacity(0.8))
                }
                
                Text(postcard.message)
                    .font(.body)
                    .foregroundColor(AppColors.primary)
                    .lineLimit(2)
                
                if !postcard.imageName.isEmpty {
                    Image(postcard.imageName)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(height: 100)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 5)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            NavigationStack {
                PostcardDetailView(postcard: postcard)
            }
        }
    }
}

#Preview {
    PetView()
        .environmentObject(AuthenticationService())
}

#Preview("Postcards") {
    PostcardListView(pet: .constant(Pet(name: "Frodo", species: .frog)))
} 