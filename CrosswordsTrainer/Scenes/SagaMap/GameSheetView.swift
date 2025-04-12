//
//  GameSheetView.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 12/04/2025.
//


import SwiftUI
import Observation

struct GameSheetView: View {
  var appState: AppStateManager
  var day: Day
  @Binding var isPresented: Bool

  // Track whether the game is completed to show a celebration UI
  @State private var showingCompletionCelebration = false

  // Access the game view model through the app state
  private var gameViewModel: GameViewModel {
    appState.gameViewModel
  }

  var body: some View {
    NavigationView {
      ZStack {
        // Main game content
        VStack(spacing: 12) {
          // Header controls
          VStack(spacing: 8) {
            HStack {
              VStack(alignment: .leading, spacing: 4) {
                Text(day.title)
                  .font(.title2)
                  .fontWeight(.bold)

                Text(day.formattedDate)
                  .font(.subheadline)
                  .foregroundColor(.secondary)
              }

              Spacer()

              Button {
                isPresented = false
              } label: {
                Text("Done")
                  .fontWeight(.medium)
              }
              .buttonStyle(.bordered)
            }

            // Challenge description
            Text(day.description)
              .font(.body)
              .multilineTextAlignment(.center)
              .padding(.vertical, 8)

            // Progress section
            VStack(spacing: 4) {
              HStack {
                Text("\(gameViewModel.completedCount) of \(gameViewModel.facts.count) solved")
                  .font(.caption)
                  .foregroundColor(.secondary)

                Spacer()

                // Conditionally show energy that will be earned upon completion
                if !gameViewModel.isGameCompleted {
                  HStack(spacing: 4) {
                    Text("Complete to earn")
                      .font(.caption)
                      .foregroundColor(.secondary)

                    Image(systemName: "bolt.fill")
                      .font(.caption)
                      .foregroundColor(.yellow)

                    Text("20")
                      .font(.caption)
                      .fontWeight(.bold)
                      .foregroundColor(.secondary)
                  }
                }
              }

              ProgressView(value: gameViewModel.progressPercentage, total: 100)
                .animation(.bouncy, value: gameViewModel.progressPercentage)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(progressTint)
            }
          }
          .padding(.horizontal)

          // Clues grid
          ScrollView {
            ForEach(gameViewModel.facts) { fact in
              FactClueCell(fact: fact, appState: appState)
                .padding(.bottom, 8)
            }
            .padding(.horizontal)
            .padding(.bottom)
          }
        }

        // Completion celebration overlay
        if showingCompletionCelebration {
          completionView
        }
      }
      .navigationBarHidden(true)
      .onAppear {
        // Set up the completion handler
        setupCompletionHandler()
      }
    }
  }

  private var progressTint: Color {
    if gameViewModel.isGameCompleted {
      return .green
    } else {
      return .blue
    }
  }

  private var completionView: some View {
    ZStack {
      // Semi-transparent background
      Color.black.opacity(0.7)
        .edgesIgnoringSafeArea(.all)

      // Celebration content
      VStack(spacing: 20) {
        Text("Day Completed!")
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.white)

        Image(systemName: "checkmark.circle.fill")
          .font(.system(size: 80))
          .foregroundColor(.green)

        Text("You've earned")
          .font(.title2)
          .foregroundColor(.white)

        HStack(spacing: 8) {
          Image(systemName: "bolt.fill")
            .font(.title)
            .foregroundColor(.yellow)

          Text("20 Energy")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
        }

        Button {
          // Dismiss the sheet when done
          isPresented = false
        } label: {
          Text("Back to Map")
            .font(.title3)
            .fontWeight(.semibold)
            .padding()
            .frame(width: 220)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding(.top, 20)
      }
      .padding(30)
      .background(Color(.systemGray6).opacity(0.9))
      .cornerRadius(20)
      .shadow(radius: 10)
    }
    .transition(.opacity)
  }

  private func setupCompletionHandler() {
    gameViewModel.onGameCompletion = {
      // Mark the day as completed in the progress view model
      appState.progressViewModel.completeDay(day.id)

      // Show the completion celebration with a slight delay
      withAnimation(.easeIn(duration: 0.5)) {
        // A short delay makes it feel more natural
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          showingCompletionCelebration = true
        }
      }
    }
  }
}



#Preview {
  // Create a sample day for preview
  let sampleDay = Day(
    id: 1,
    date: Date(),
    title: "Day 1",
    description: "Your first knowledge challenge",
    facts: Fact.initialFacts,
    requiredEnergy: 0
  )

  return GameSheetView(
    appState: AppStateManager(),
    day: sampleDay,
    isPresented: .constant(true)
  )
}
