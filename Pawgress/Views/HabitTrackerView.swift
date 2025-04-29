import SwiftUI

struct HabitTrackerView: View {
    @State private var selectedDate = Date()
    @State private var habits: [Habit] = []
    @State private var showingNewTask = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Calendar Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Habit Tracker +")
                                .font(.title)
                                .bold()
                                .foregroundColor(AppColors.primary)
                            
                            CalendarView(selectedDate: $selectedDate)
                        }
                        .padding(.horizontal)
                        
                        // Start Focus Button
                        Button(action: { /* TODO: Implement focus timer */ }) {
                            Text("START FOCUS")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.secondary)
                                .cornerRadius(15)
                        }
                        .padding(.horizontal)
                        
                        // Mascot and Motivation
                        VStack(spacing: 8) {
                            Image("frog_mascot")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                            
                            Text("Let's do our best today~")
                                .font(.headline)
                                .foregroundColor(AppColors.primary)
                        }
                        
                        // Habits List
                        VStack(spacing: 12) {
                            ForEach(habits) { habit in
                                HabitRow(habit: habit)
                            }
                            
                            if habits.isEmpty {
                                Text("No habits yet. Add one to get started!")
                                    .foregroundColor(AppColors.primary.opacity(0.6))
                                    .padding()
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationBarItems(trailing: Button(action: { showingNewTask = true }) {
                Image(systemName: "plus")
                    .foregroundColor(AppColors.primary)
            })
            .sheet(isPresented: $showingNewTask) {
                NewTaskView(isPresented: $showingNewTask, habits: $habits)
            }
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    private let calendar = Calendar.current
    private let monthFormatter = DateFormatter()
    private let dayFormatter = DateFormatter()
    private let weekDayFormatter = DateFormatter()
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        monthFormatter.dateFormat = "MMMM yyyy"
        dayFormatter.dateFormat = "d"
        weekDayFormatter.dateFormat = "EEEEE"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("\(monthFormatter.string(from: selectedDate))")
                    .font(.title2)
                    .bold()
                    .foregroundColor(AppColors.primary)
                Spacer()
            }
            
            // Days of week
            HStack {
                ForEach(0..<7, id: \.self) { index in
                    let weekday = calendar.date(from: DateComponents(weekday: index + 1))!
                    Text(weekDayFormatter.string(from: weekday))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(AppColors.primary)
                }
            }
            
            // Calendar grid
            let days = calendar.range(of: .day, in: .month, for: selectedDate)!
            let firstWeekday = calendar.component(.weekday, from: selectedDate)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(0..<firstWeekday-1, id: \.self) { _ in
                    Text("")
                }
                
                ForEach(days, id: \.self) { day in
                    let date = calendar.date(from: DateComponents(year: calendar.component(.year, from: selectedDate),
                                                               month: calendar.component(.month, from: selectedDate),
                                                               day: day))!
                    
                    Text(dayFormatter.string(from: date))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            calendar.isDate(date, inSameDayAs: selectedDate) ?
                            AppColors.secondary : Color.clear
                        )
                        .cornerRadius(8)
                        .foregroundColor(
                            calendar.isDate(date, inSameDayAs: selectedDate) ?
                            .white : AppColors.primary
                        )
                        .onTapGesture {
                            selectedDate = date
                        }
                }
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(15)
    }
}

struct HabitRow: View {
    let habit: Habit
    
    var body: some View {
        HStack {
            Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(habit.isCompleted ? AppColors.secondary : AppColors.primary)
            
            VStack(alignment: .leading) {
                Text(habit.title)
                    .font(.headline)
                if !habit.description.isEmpty {
                    Text(habit.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 2)
    }
}

struct NewTaskView: View {
    @Binding var isPresented: Bool
    @Binding var habits: [Habit]
    @State private var title = ""
    @State private var description = ""
    @State private var selectedIcon: String?
    
    let icons = ["book.fill", "fork.knife", "pencil", "heart.fill", "star.fill", "moon.fill",
                 "sun.max.fill", "cloud.fill", "bolt.fill", "leaf.fill", "flame.fill"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("New Task")
                            .font(.title2)
                            .bold()
                            .foregroundColor(AppColors.primary)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            TextField("Input Your Goal", text: $title)
                                .textFieldStyle(RoundedTextFieldStyle())
                            
                            TextField("Time Plan", text: $description)
                                .textFieldStyle(RoundedTextFieldStyle())
                            
                            Text("Select Icons")
                                .font(.headline)
                                .foregroundColor(AppColors.primary)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 16) {
                                ForEach(icons, id: \.self) { icon in
                                    Image(systemName: icon)
                                        .font(.title2)
                                        .foregroundColor(selectedIcon == icon ? .white : AppColors.primary)
                                        .frame(width: 40, height: 40)
                                        .background(
                                            selectedIcon == icon ? AppColors.secondary : Color.white
                                        )
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            selectedIcon = icon
                                        }
                                }
                            }
                        }
                        .padding()
                        .background(AppColors.cardBackground)
                        .cornerRadius(15)
                        
                        Button(action: {
                            let newHabit = Habit(title: title, description: description)
                            habits.append(newHabit)
                            isPresented = false
                        }) {
                            Text("Done")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.secondary)
                                .cornerRadius(15)
                        }
                        .disabled(title.isEmpty)
                    }
                    .padding()
                }
            }
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

#Preview {
    HabitTrackerView()
        .environmentObject(AuthenticationService())
} 