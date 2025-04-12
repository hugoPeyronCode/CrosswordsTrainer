//
//  AppStateManager.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 12/04/2025.
//

import SwiftUI
import Observation

/// Central coordinator for app-wide state management
@Observable
class AppStateManager {
  // Main models
  var gameViewModel: GameViewModel
  var progressViewModel: ProgressViewModel

  // App navigation state
  var viewMode: ViewMode = .saga

  enum ViewMode {
    case saga, train
  }

  // Currently selected day for game mode
  var selectedDay: Day?

  // MARK: - Initialization

  init() {
    // Initialize component view models
    self.gameViewModel = GameViewModel()
    self.progressViewModel = ProgressViewModel()

    // Set up initial game facts (for training mode)
    self.gameViewModel.setupGameWithFacts(Fact.initialFacts)

    // Connect view models
    setupViewModelConnections()
  }

  // MARK: - Inter-ViewModel Communication

  private func setupViewModelConnections() {
    // Connect game completion to progress tracking
    gameViewModel.onGameCompletion = { [weak self] in
      guard let self = self, let selectedDay = self.selectedDay else { return }
      self.progressViewModel.completeDay(selectedDay.id)
    }
  }

  // MARK: - Day Selection

  /// Select a day to play and initialize the game
  func selectDay(_ day: Day) {
    selectedDay = day
    gameViewModel.setupGameWithFacts(day.facts)
    viewMode = .saga
  }

  /// Check if user can play a particular day
  func canPlayDay(_ day: Day) -> Bool {
    return progressViewModel.isDayAvailable(day)
  }
  
  /// Attempt to unlock a past day using energy
  func tryUnlockDay(_ day: Day) -> Bool {
    return progressViewModel.unlockDay(day)
  }

  // MARK: - Navigation

  /// Return to saga map from game
  func returnToMap() {
    viewMode = .saga
  }

  /// Switch to training mode
  func switchToTrainingMode() {
    // Use a default set of facts for training
    gameViewModel.setupGameWithFacts(Fact.initialFacts)
  }
}
