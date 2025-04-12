//
//  ProgressViewModel.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 12/04/2025.
//

import SwiftUI
import Observation

/// ViewModel focused on user progression and day management
@Observable
class ProgressViewModel {

  var days: [Day] = []
  var user: User
  var currentDayIndex: Int = 0

  private let dataStore = DataStore()

  init() {
      // Use local variables first
      var loadedDays: [Day] = []

      // Load days
      if let savedDays = dataStore.loadDays() {
          loadedDays = savedDays
      } else {
          loadedDays = dataStore.generateDays(count: 30)
          dataStore.saveDays(loadedDays)
      }

      // Initialize ALL stored properties first
      self.days = loadedDays
      self.user = dataStore.loadUser()

      // Now that all stored properties are initialized,
      // we can safely use methods that access 'self'
      calculateCurrentDayIndex()
      checkAndResetDailyProgress()
  }
  // MARK: - Day Management

  private func calculateCurrentDayIndex() {
    let calendar = Calendar.current
    if let firstDay = days.first?.date {
      let components = calendar.dateComponents([.day], from: firstDay, to: Date())
      if let daysSinceStart = components.day {
        currentDayIndex = min(max(0, daysSinceStart), days.count - 1)
      }
    }
  }

  func updateCurrentDayIndex() {
    calculateCurrentDayIndex()
  }

  // MARK: - Game Progress Management

  // Check if a day is available to play
  func isDayAvailable(_ day: Day) -> Bool {
    let dayIndex = days.firstIndex(where: { $0.id == day.id }) ?? 0

    // Today's day is always available
    if dayIndex == currentDayIndex {
      return true
    }

    // Future days are not available
    if dayIndex > currentDayIndex {
      return false
    }

    // Past days are available if completed or if user has enough energy
    return user.completedDays.contains(day.id) || user.energy >= day.requiredEnergy
  }

  // Unlock a past day using energy
  func unlockDay(_ day: Day) -> Bool {
    guard !isDayAvailable(day) else { return true } // Already available

    if user.energy >= day.requiredEnergy {
      user.energy -= day.requiredEnergy
      saveUserData()
      return true
    }

    return false
  }

  // Mark a day as completed
  func completeDay(_ dayId: Int) {
    if !user.completedDays.contains(dayId) {
      user.completedDays.append(dayId)

      // Find the day and mark it as completed
      if let index = days.firstIndex(where: { $0.id == dayId }) {
        days[index].isCompleted = true
      }

      // Award energy for completing a day
      user.energy += 20
      saveUserData()
    }
  }

  // MARK: - Daily Progress

  func checkAndResetDailyProgress() {
    guard let lastPlayed = user.lastPlayedDate else {
      user.lastPlayedDate = Date()
      saveUserData()
      return
    }

    let calendar = Calendar.current
    if !calendar.isDate(lastPlayed, inSameDayAs: Date()) {
      // It's a new day
      user.lastPlayedDate = Date()

      // Award daily energy bonus
      user.energy += 50

      // Update current day index
      updateCurrentDayIndex()

      saveUserData()
    }
  }

  // MARK: - Persistence

  private func saveUserData() {
    dataStore.saveUser(user)
    dataStore.saveDays(days)
  }
}
