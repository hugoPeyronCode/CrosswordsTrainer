//
//  SagaMapViewModel.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 12/04/2025.
//


import SwiftUI
import Observation

@Observable
class SagaMapViewModel {
    var days: [Day] = []
    var user: User
    var currentDayIndex: Int = 0
    private let dataStore = DataStore()

    // Computed property to get today's date
    var currentDate: Date {
        return Date()
    }

    // Initialization - fixed to avoid accessing properties before fully initialized
    init() {
        // First initialize all stored properties
        var loadedDays: [Day] = []

        // Load data from persistent storage
        if let savedDays = dataStore.loadDays() {
            loadedDays = savedDays
        } else {
            // Generate initial data if none exists
            loadedDays = dataStore.generateDays(count: 30)
            dataStore.saveDays(loadedDays)
        }

        // Load user
        self.user = dataStore.loadUser()

        // Set days property
        self.days = loadedDays

        // After all properties are initialized, calculate current day index
        self.calculateCurrentDayIndex()
    }

    // Calculate which day we're on based on the calendar
    private func calculateCurrentDayIndex() {
        let calendar = Calendar.current
        if let firstDay = days.first?.date {
            let components = calendar.dateComponents([.day], from: firstDay, to: currentDate)
            if let daysSinceStart = components.day {
                currentDayIndex = min(max(0, daysSinceStart), days.count - 1)
            }
        }
    }

    // Update current day - safe to call after initialization
    func updateCurrentDayIndex() {
        calculateCurrentDayIndex()
    }

    // Rest of your methods...

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

    // Reset progress at the beginning of a new day
    func checkAndResetDailyProgress() {
        guard let lastPlayed = user.lastPlayedDate else {
            user.lastPlayedDate = currentDate
            saveUserData()
            return
        }

        let calendar = Calendar.current
        if !calendar.isDate(lastPlayed, inSameDayAs: currentDate) {
            // It's a new day
            user.lastPlayedDate = currentDate

            // Award daily energy bonus
            user.energy += 50

            // Update current day index
            updateCurrentDayIndex()

            saveUserData()
        }
    }

    // Save user data changes
    private func saveUserData() {
        dataStore.saveUser(user)
        dataStore.saveDays(days)
    }
}