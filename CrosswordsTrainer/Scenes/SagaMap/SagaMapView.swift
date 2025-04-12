//
//  SagaMapView.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 12/04/2025.
//

import SwiftUI
import Observation

struct SagaMapView: View {
  var appState: AppStateManager
  @State private var showingEnergyAlert = false
  @State private var showingGameSheet = false
  @State private var selectedDay: Day? = nil

  // Access the progress view model through the app state
  private var viewModel: ProgressViewModel {
    appState.progressViewModel
  }

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
      .alert("Not Enough Energy", isPresented: $showingEnergyAlert) {
        Button("OK", role: .cancel) {}
      } message: {
        Text("You need more energy to unlock this day. Complete today's challenge to earn energy!")
      }
      .fullScreenCover(isPresented: $showingGameSheet) {
        // Present the game view as a full-screen sheet
        if let day = selectedDay {
          GameSheetView(appState: appState, day: day, isPresented: $showingGameSheet)
        }
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
      handleDaySelection(day, isAvailable: isAvailable, isPastDay: isPastDay)
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

  // Handle tapping on a day cell
  private func handleDaySelection(_ day: Day, isAvailable: Bool, isPastDay: Bool) {
    if isAvailable {
      selectedDay = day
      presentGameSheet(for: day)
    } else if isPastDay {
      if appState.tryUnlockDay(day) {
        selectedDay = day
        presentGameSheet(for: day)
      } else {
        showingEnergyAlert = true
      }
    }
  }

  // Present the game sheet for the selected day
  private func presentGameSheet(for day: Day) {
    // Load the facts for the selected day into the game view model
    appState.gameViewModel.setupGameWithFacts(day.facts)
    appState.selectedDay = day

    // Show the full-screen sheet
    showingGameSheet = true
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
}

