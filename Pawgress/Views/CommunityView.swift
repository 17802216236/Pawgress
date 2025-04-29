import SwiftUI

struct Story: Identifiable {
    let id = UUID()
    let username: String
    let content: String
    let avatar: String
    var likes: Int = 0
    var comments: Int = 0
    let tags: [String]
}

struct CommunityView: View {
    @State private var selectedTab = 0
    @State private var showingNewPost = false
    @State private var stories: [Story] = [
        Story(username: "Frodo_Lover", 
              content: "Today I finally found the courage to talk to my parents about my feelings.",
              avatar: "frog_icon",
              tags: ["Growth"]),
        Story(username: "TinySunshine",
              content: "Yesterday I got up early and made my favorite breakfast.",
              avatar: "sun_icon",
              tags: ["Growth", "Emo"]),
        Story(username: "Crying_Mouse",
              content: "I think I secretly miss someone again.",
              avatar: "mouse_icon",
              tags: ["Friendship"])
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Quote
                        VStack(spacing: 8) {
                            Text("Community")
                                .font(.title)
                                .bold()
                                .foregroundColor(AppColors.primary)
                            
                            Text("\"The secret of getting ahead is getting started.\" - Mark Twain")
                                .font(.subheadline)
                                .foregroundColor(AppColors.primary.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // New Post Button
                        Button(action: { showingNewPost = true }) {
                            HStack {
                                Text("Share a story...")
                                    .foregroundColor(AppColors.primary.opacity(0.6))
                                Spacer()
                                Text("New Post")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(AppColors.accent)
                                    .cornerRadius(15)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                        }
                        .padding(.horizontal)
                        
                        // Tags
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(["Growth", "Emo", "Friendship"], id: \.self) { tag in
                                    Text(tag)
                                        .font(.subheadline)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(AppColors.accent)
                                        .foregroundColor(.white)
                                        .cornerRadius(20)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Stories
                        VStack(spacing: 16) {
                            ForEach(stories) { story in
                                StoryCard(story: story)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .sheet(isPresented: $showingNewPost) {
                NewPostView(isPresented: $showingNewPost, stories: $stories)
            }
        }
    }
}

struct StoryCard: View {
    let story: Story
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Author Info
            HStack {
                Image(story.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Text(story.username)
                    .font(.headline)
                    .foregroundColor(AppColors.primary)
            }
            
            // Content
            Text(story.content)
                .font(.body)
                .foregroundColor(AppColors.primary)
            
            // Tags
            HStack {
                ForEach(story.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.secondary.opacity(0.2))
                        .foregroundColor(AppColors.primary)
                        .cornerRadius(10)
                }
            }
            
            // Interaction Buttons
            HStack {
                Spacer()
                Button(action: { isLiked.toggle() }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : AppColors.primary)
                }
                
                Button(action: { /* TODO: Implement comments */ }) {
                    Image(systemName: "bubble.right")
                        .foregroundColor(AppColors.primary)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}

struct NewPostView: View {
    @Binding var isPresented: Bool
    @Binding var stories: [Story]
    @State private var content = ""
    @State private var selectedTags: Set<String> = []
    
    let availableTags = ["Growth", "Emo", "Friendship"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    TextField("What's on your mind today?", text: $content, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 100)
                    
                    // Tag Selection
                    VStack(alignment: .leading) {
                        Text("Select Tags")
                            .font(.headline)
                            .foregroundColor(AppColors.primary)
                        
                        HStack {
                            ForEach(availableTags, id: \.self) { tag in
                                TagButton(tag: tag, isSelected: selectedTags.contains(tag)) {
                                    if selectedTags.contains(tag) {
                                        selectedTags.remove(tag)
                                    } else {
                                        selectedTags.insert(tag)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        let newStory = Story(username: "You",
                                           content: content,
                                           avatar: "frog_icon",
                                           tags: Array(selectedTags))
                        stories.insert(newStory, at: 0)
                        isPresented = false
                    }
                    .disabled(content.isEmpty)
                }
            }
        }
    }
}

struct TagButton: View {
    let tag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.accent : Color.white)
                .foregroundColor(isSelected ? .white : AppColors.primary)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.accent, lineWidth: 1)
                )
        }
    }
}

#Preview {
    CommunityView()
        .environmentObject(AuthenticationService())
}

#Preview("New Post") {
    NewPostView(isPresented: .constant(true), stories: .constant([]))
} 