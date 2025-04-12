//
//  SagaMapView.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 12/04/2025.
//

import SwiftUI
import Observation

struct SagaMapView: View {
  @State private var viewModel = SagaMapViewModel()
  @State private var selectedDay: Day?
  @State private var showingEnergyAlert = false
  @State private var showingGameView = false

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 20) {
          // User stats section
          userStatsView

          // Day map section
          dayMapView
        }
        .padding()
      }
      .navigationTitle("Knowledge Journey")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          energyDisplay
        }
      }
      .sheet(isPresented: $showingGameView) {
        if let selectedDay = selectedDay {
          WordGameView(viewModel: createGameViewModel(for: selectedDay))
        }
      }
      .alert("Not Enough Energy", isPresented: $showingEnergyAlert) {
        Button("OK", role: .cancel) {}
      } message: {
        Text("You need more energy to unlock this day. Complete today's challenge to earn energy!")
      }
      .onAppear {
        viewModel.checkAndResetDailyProgress()
      }
    }
  }

  // User stats section
  private var userStatsView: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Your Progress")
        .font(.title2)
        .fontWeight(.bold)

      HStack {
        VStack(alignment: .leading) {
          Text("Energy")
            .font(.subheadline)
            .foregroundColor(.secondary)

          Text("\(viewModel.user.energy)")
            .font(.title3)
            .fontWeight(.bold)
        }

        Spacer()

        VStack(alignment: .leading) {
          Text("Days Completed")
            .font(.subheadline)
            .foregroundColor(.secondary)

          Text("\(viewModel.user.completedDays.count)")
            .font(.title3)
            .fontWeight(.bold)
        }

        Spacer()

        VStack(alignment: .leading) {
          Text("Current Day")
            .font(.subheadline)
            .foregroundColor(.secondary)

          Text("\(viewModel.currentDayIndex + 1)")
            .font(.title3)
            .fontWeight(.bold)
        }
      }
      .padding()
      .background(Color(.systemBackground))
      .cornerRadius(12)
      .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
  }

  // Energy display in the toolbar
  private var energyDisplay: some View {
    HStack {
      Image(systemName: "bolt.fill")
        .foregroundColor(.yellow)
      Text("\(viewModel.user.energy)")
        .fontWeight(.bold)
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 4)
    .background(Color(.systemGray6))
    .cornerRadius(12)
  }

  // Day map grid
  private var dayMapView: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Knowledge Journey")
        .font(.title2)
        .fontWeight(.bold)

      LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 15) {
        ForEach(viewModel.days) { day in
          dayCell(for: day)
        }
      }
    }
  }

  // Individual day cell
  private func dayCell(for day: Day) -> some View {
    let dayIndex = viewModel.days.firstIndex(where: { $0.id == day.id }) ?? 0
    let isAvailable = viewModel.isDayAvailable(day)
    let isCurrentDay = dayIndex == viewModel.currentDayIndex
    let isFutureDay = dayIndex > viewModel.currentDayIndex
    let isPastDay = dayIndex < viewModel.currentDayIndex

    return Button(action: {
      if isAvailable {
        selectedDay = day
        showingGameView = true
      } else if isPastDay {
        if viewModel.unlockDay(day) {
          selectedDay = day
          showingGameView = true
        } else {
          showingEnergyAlert = true
        }
      }
    }) {
      VStack(spacing: 8) {
        Circle()
          .fill(cellBackgroundColor(for: day))
          .frame(width: 70, height: 70)
          .overlay(
            Group {
              if isAvailable {
                Text("\(day.id)")
                  .font(.title2)
                  .fontWeight(.bold)
                  .foregroundColor(.white)
              } else if isFutureDay {
                Image(systemName: "lock.fill")
                  .font(.title2)
                  .foregroundColor(.white)
              } else {
                VStack {
                  Image(systemName: "bolt.fill")
                    .font(.body)
                  Text("\(day.requiredEnergy)")
                    .font(.caption)
                    .fontWeight(.bold)
                }
                .foregroundColor(.white)
              }
            }
          )
          .shadow(color: isCurrentDay ? Color.blue.opacity(0.5) : Color.clear, radius: 5)

        Text(day.title)
          .font(.caption)
          .fontWeight(isCurrentDay ? .bold : .regular)

        Text(day.formattedDate)
          .font(.caption2)
          .foregroundColor(.secondary)
      }
      .opacity(isAvailable || isCurrentDay ? 1.0 : 0.7)
      .padding(8)
      .background(isCurrentDay ? Color.blue.opacity(0.1) : Color.clear)
      .cornerRadius(12)
    }
    .disabled(isFutureDay)
  }

  // Cell background color based on status
  private func cellBackgroundColor(for day: Day) -> Color {
    let dayIndex = viewModel.days.firstIndex(where: { $0.id == day.id }) ?? 0

    if day.isCompleted {
      return .green // Completed day
    } else if dayIndex == viewModel.currentDayIndex {
      return .blue // Today
    } else if dayIndex > viewModel.currentDayIndex {
      return .gray // Future (locked)
    } else {
      return .orange // Past (needs energy)
    }
  }

  // Create game view model for a specific day
  private func createGameViewModel(for day: Day) -> KnowledgeViewModel {
    let vm = KnowledgeViewModel()
    vm.facts = day.facts

    // Set completion handler
    vm.onCompletion = {
      viewModel.completeDay(day.id)
    }

    return vm
  }
}

// MARK: - Data Persistence Layer

class DataStore {
  private let userDefaultsKey = "com.crosswordstrainer.userdata"
  private let daysDefaultsKey = "com.crosswordstrainer.days"

  // Save user data
  func saveUser(_ user: User) {
    if let encoded = try? JSONEncoder().encode(user) {
      UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
    }
  }

  // Load user data
  func loadUser() -> User {
    if let userData = UserDefaults.standard.data(forKey: userDefaultsKey),
       let user = try? JSONDecoder().decode(User.self, from: userData) {
      return user
    }
    return User()
  }

  // Save days data
  func saveDays(_ days: [Day]) {
    if let encoded = try? JSONEncoder().encode(days) {
      UserDefaults.standard.set(encoded, forKey: daysDefaultsKey)
    }
  }

  // Load days data
  func loadDays() -> [Day]? {
    if let daysData = UserDefaults.standard.data(forKey: daysDefaultsKey),
       let days = try? JSONDecoder().decode([Day].self, from: daysData) {
      return days
    }
    return nil
  }

  // Generate initial days
  func generateDays(count: Int, startingFrom startDate: Date = Date()) -> [Day] {
    var days: [Day] = []
    let calendar = Calendar.current

    // Create sample facts to distribute across days
    let allFacts = createSampleFacts()
    let factsPerDay = max(5, allFacts.count / count) // At least 5 facts per day

    for i in 0..<count {
      // Calculate date for this day
      guard let date = calendar.date(byAdding: .day, value: i, to: startDate) else {
        continue
      }

      // Select facts for this day
      let startIndex = (i * factsPerDay) % allFacts.count
      var dayFacts: [Fact] = []

      for j in 0..<factsPerDay {
        let factIndex = (startIndex + j) % allFacts.count
        dayFacts.append(allFacts[factIndex])
      }

      // Create day
      let day = Day(
        id: i + 1,
        date: date,
        title: "Day \(i + 1)",
        description: "Knowledge challenge for \(formatDate(date))",
        facts: dayFacts,
        requiredEnergy: 25 + (i * 5) // Increasing energy requirement for later days
      )

      days.append(day)
    }

    return days
  }

  private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
  }

  private func createSampleFacts() -> [Fact] {
    return Fact.initialFacts + Fact.additionalFacts
  }
}
