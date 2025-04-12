//
//  DataStore.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 12/04/2025.
//

import SwiftUI

/// Data persistence layer for the app
class DataStore {
  private let userDefaultsKey = "com.crosswordstrainer.userdata"
  private let daysDefaultsKey = "com.crosswordstrainer.days"
  
  // MARK: - User Data
  
  /// Save user data
  func saveUser(_ user: User) {
    if let encoded = try? JSONEncoder().encode(user) {
      UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
    }
  }
  
  /// Load user data
  func loadUser() -> User {
    if let userData = UserDefaults.standard.data(forKey: userDefaultsKey),
       let user = try? JSONDecoder().decode(User.self, from: userData) {
      return user
    }
    return User()
  }
  
  // MARK: - Days Data
  
  /// Save days data
  func saveDays(_ days: [Day]) {
    if let encoded = try? JSONEncoder().encode(days) {
      UserDefaults.standard.set(encoded, forKey: daysDefaultsKey)
    }
  }
  
  /// Load days data
  func loadDays() -> [Day]? {
    if let daysData = UserDefaults.standard.data(forKey: daysDefaultsKey),
       let days = try? JSONDecoder().decode([Day].self, from: daysData) {
      return days
    }
    return nil
  }
  
  // MARK: - Initial Data Generation
  
  /// Generate initial days
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