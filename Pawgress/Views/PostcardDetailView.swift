import SwiftUI

struct PostcardDetailView: View {
    let postcard: Postcard
    @Environment(\.dismiss) var dismiss
    @State private var isFlipped = false
    @State private var showingShareSheet = false
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Postcard Image
                    ZStack {
                        if isFlipped {
                            // Back of postcard
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Dear Friend,")
                                        .font(.title3)
                                        .foregroundColor(AppColors.primary)
                                    Spacer()
                                }
                                
                                Text(postcard.message)
                                    .font(.body)
                                    .foregroundColor(AppColors.primary)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                HStack {
                                    Spacer()
                                    Text("With love from \(postcard.planet.rawValue)")
                                        .font(.caption)
                                        .foregroundColor(AppColors.primary.opacity(0.8))
                                }
                            }
                            .padding(24)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.1), radius: 10)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        } else {
                            // Front of postcard
                            VStack {
                                if !postcard.imageName.isEmpty {
                                    Image(postcard.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(15)
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .foregroundColor(AppColors.secondary)
                                }
                                
                                Text(postcard.planet.rawValue)
                                    .font(.title)
                                    .padding(.top, 8)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.1), radius: 10)
                        }
                    }
                    .frame(height: 400)
                    .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    .animation(.spring(duration: 0.6), value: isFlipped)
                    .onTapGesture {
                        withAnimation {
                            isFlipped.toggle()
                        }
                    }
                    
                    // Instructions
                    Text("Tap the postcard to flip it!")
                        .font(.caption)
                        .foregroundColor(AppColors.primary.opacity(0.6))
                    
                    // Share Button
                    Button(action: {
                        showingShareSheet = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Postcard")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.accent)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("From \(postcard.planet.rawValue)")
        .sheet(isPresented: $showingShareSheet) {
            if let image = renderPostcard() {
                ShareSheet(items: [image])
            }
        }
    }
    
    private func renderPostcard() -> UIImage? {
        // TODO: Implement postcard rendering for sharing
        return nil
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationView {
        PostcardDetailView(postcard: Postcard(
            planet: .moon,
            message: "Having a wonderful time exploring the moon! The Earth looks beautiful from up here. Miss you!",
            imageName: "moon_postcard",
            unlockRequirement: 5
        ))
    }
} 