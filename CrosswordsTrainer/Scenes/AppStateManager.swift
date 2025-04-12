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
  }

  // MARK: - Day Selection

  /// Check if user can play a particular day
  func canPlayDay(_ day: Day) -> Bool {
    return progressViewModel.isDayAvailable(day)
  }

  /// Attempt to unlock a past day using energy
  func tryUnlockDay(_ day: Day) -> Bool {
    return progressViewModel.unlockDay(day)
  }

  // MARK: - Navigation

  /// Switch to training mode
  func switchToTrainingMode() {
    // Use a default set of facts for training
    gameViewModel.setupGameWithFacts(Fact.initialFacts)
    viewMode = .train
  }
}

// MARK: - Array Extension

extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
