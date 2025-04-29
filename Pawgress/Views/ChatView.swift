import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isFromPet: Bool
    let timestamp = Date()
}

struct ChatView: View {
    let pet: Pet
    @Environment(\.dismiss) var dismiss
    @State private var messages: [Message] = []
    @State private var newMessage = ""
    @State private var showingSuggestions = false
    
    let suggestions = [
        "How are you today?",
        "Tell me about your journey",
        "What's your favorite planet?",
        "Can you share a story?",
        "Give me some motivation"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Chat messages
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                            }
                        }
                        .padding()
                    }
                    
                    // Suggestion chips
                    if showingSuggestions && messages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(suggestions, id: \.self) { suggestion in
                                    Button(action: {
                                        sendMessage(suggestion)
                                    }) {
                                        Text(suggestion)
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.primary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color.white)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    
                    // Message input
                    HStack(spacing: 12) {
                        TextField("Type a message...", text: $newMessage)
                            .textFieldStyle(RoundedTextFieldStyle())
                        
                        Button(action: {
                            if !newMessage.isEmpty {
                                sendMessage(newMessage)
                                newMessage = ""
                            }
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                                .foregroundColor(newMessage.isEmpty ? AppColors.primary.opacity(0.5) : AppColors.accent)
                        }
                    }
                    .padding()
                    .background(Color.white)
                }
            }
            .navigationTitle("Chat with \(pet.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                showingSuggestions = true
                // Welcome message
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    messages.append(Message(content: "Hi! I'm \(pet.name). What would you like to talk about?", isFromPet: true))
                }
            }
        }
    }
    
    private func sendMessage(_ content: String) {
        messages.append(Message(content: content, isFromPet: false))
        showingSuggestions = false
        
        // Simulate pet response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = generatePetResponse(to: content)
            messages.append(Message(content: response, isFromPet: true))
        }
    }
    
    private func generatePetResponse(to message: String) -> String {
        // Simple response generation based on keywords
        let lowercased = message.lowercased()
        
        if lowercased.contains("how are you") {
            return "I'm doing great! Just got back from exploring \(pet.currentPlanet.rawValue). The view was amazing!"
        } else if lowercased.contains("journey") || lowercased.contains("travel") {
            return "I love traveling through space! Each planet has its own unique beauty. Right now, I'm fascinated by \(pet.currentPlanet.rawValue)."
        } else if lowercased.contains("planet") {
            return "Earth is my home, but I'm really excited about visiting Saturn next. Those rings are spectacular! ✨"
        } else if lowercased.contains("story") {
            return "Once, while visiting the moon, I made friends with a star. We spent hours talking about dreams and cosmic adventures. 🌟"
        } else if lowercased.contains("motivation") || lowercased.contains("inspire") {
            return "Remember: Every small step you take is progress. Just like how I explore space one planet at a time, you can achieve your goals one step at a time! 💫"
        } else {
            let responses = [
                "That's interesting! Tell me more about it.",
                "I love chatting with you! It makes my space journey even more special.",
                "You know, that reminds me of a beautiful constellation I saw recently...",
                "Your thoughts are as vast as the universe itself!",
                "Let's keep exploring and growing together!"
            ]
            return responses.randomElement() ?? "That's fascinating!"
        }
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromPet {
                Image("frog_mascot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            } else {
                Spacer()
            }
            
            Text(message.content)
                .padding()
                .background(message.isFromPet ? Color.white : AppColors.accent)
                .foregroundColor(message.isFromPet ? AppColors.primary : .white)
                .cornerRadius(20)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: message.isFromPet ? .leading : .trailing)
            
            if !message.isFromPet {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundColor(AppColors.primary)
            } else {
                Spacer()
            }
        }
    }
}

#Preview {
    ChatView(pet: Pet(name: "Frodo", species: .frog))
} 